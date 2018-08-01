//
//  GameCharacter.swift
//  xxk
//
//  Created by ReseBeta@WeShape on 2018/7/26.
//  Copyright © 2018年 xxk. All rights reserved.
//

import UIKit
import SceneKit


enum ActionState: Int {
    case actionStateNone = 0
    case actionStateIdle
    case actionStateWalk
    case actionStateAttack
    case actionStateHurt
}


class GameCharacter: NSObject {
    
    var environmentScene: SCNScene!
    var characterNode: SCNNode!
    var nodes: [SCNNode]!
    var walkAnimations = [CAAnimation]()
    var idleAnimations = [CAAnimation]()
    
    private var _actionState: ActionState!
    var actionState: ActionState
    {
        get
        {
            return _actionState
        }
        set(newValue)
        {
            switch newValue
            {
                case .actionStateIdle:
                    if (_actionState == newValue)
                    {}
                    else
                    {
                        _actionState = newValue
                        startIdleAnimationInScene(environmentScene)
                    }
                    break
                case .actionStateWalk:
                    if (_actionState == newValue)
                    {}
                    else
                    {
                        _actionState = newValue
                        startWalkAnimationInScene(environmentScene)
                    }
                    break
                case .actionStateNone:
                    _actionState = newValue
                    stopIdleAnimationInScene(environmentScene)
                    stopWalkAnimationInScene(environmentScene)
                    break
                default:
                    _actionState = newValue
                    stopIdleAnimationInScene(environmentScene)
                    stopWalkAnimationInScene(environmentScene)
                    break
            }
        }
    }
    
    
    // MARK: === 初始化
    init(scene: SCNScene, environment: SCNScene, name: String)
    {
        super.init()
        
        environmentScene = environment
        
        nodes = scene.rootNode.childNodes
        characterNode = SCNNode()
        
        for eachNode in nodes
        {
            characterNode.addChildNode(eachNode)
        }
        
        actionState = .actionStateNone
    }
    
    
    
    // MARK: === “走路”和“站立”动画的添加
    func startWalkAnimationInScene(_ gameScene: SCNScene)
    {
        for (i, animation) in walkAnimations.enumerated()
        {
            let key = "ANIM_" + String(i)
            gameScene.rootNode.addAnimation(animation, forKey: key)
        }
        actionState = .actionStateWalk
    }
    func stopWalkAnimationInScene(_ gameScene: SCNScene)
    {
        for i in 0..<walkAnimations.count
        {
            let key = "ANIM_" + String(i + 1)
            gameScene.rootNode.removeAnimation(forKey: key)
        }
    }
    func startIdleAnimationInScene(_ gameScene: SCNScene)
    {
        for (i, animation) in idleAnimations.enumerated()
        {
            let key = "ANIM_" + String(i)
            gameScene.rootNode.addAnimation(animation, forKey: key)
        }
        actionState = .actionStateIdle
    }
    func stopIdleAnimationInScene(_ gameScene: SCNScene)
    {
        for i in 0..<idleAnimations.count
        {
            let key = "ANIM_" + String(i + 1)
            gameScene.rootNode.removeAnimation(forKey: key)
        }
    }
}

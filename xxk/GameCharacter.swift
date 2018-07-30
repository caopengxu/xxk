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
    
    var sceneScene: SCNScene!
    var environmentScene: SCNScene!
    var characterNode: SCNNode!
    var nodes: Array<SCNNode>!
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
    var shouldStopWalkingAnimation: Bool!
    
    
    // 初始化
    init(scene: SCNScene, name: String)
    {
        super.init()
        
        sceneScene = scene
        
        nodes = Array(scene.rootNode.childNodes)
        characterNode = SCNNode()
        
        for eachNode in nodes
        {
            characterNode.addChildNode(eachNode)
        }
        
//        actionState = .actionStateNone
    }
    
    
    func startWalkAnimationInScene(_ gameScene: SCNScene)
    {
        var i = 0
        for animation in walkAnimations
        {
            let key = "ANIM_" + String(i)
            gameScene.rootNode.addAnimation(animation, forKey: key)
            i += 1
        }
        actionState = .actionStateWalk
    }
    func stopWalkAnimationInScene(_ gameScene: SCNScene)
    {
        let count = idleAnimations.count
        for i in 0..<count
        {
            let key = "ANIM_" + String(i + 1)
            gameScene.rootNode.removeAnimation(forKey: key)
        }
    }
    func startIdleAnimationInScene(_ gameScene: SCNScene)
    {
        var i = 0
        for animation in idleAnimations
        {
            let key = "ANIM_" + String(i)
            gameScene.rootNode.addAnimation(animation, forKey: key)
            i += 1
        }
    }
    func stopIdleAnimationInScene(_ gameScene: SCNScene)
    {
        let count = idleAnimations.count
        for i in 0..<count
        {
            let key = "ANIM_" + String(i + 1)
            gameScene.rootNode.removeAnimation(forKey: key)
        }
    }
}

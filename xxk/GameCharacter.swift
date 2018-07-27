//
//  GameCharacter.swift
//  xxk
//
//  Created by ReseBeta@WeShape on 2018/7/26.
//  Copyright © 2018年 xxk. All rights reserved.
//

import UIKit
import SceneKit


enum ActionState {
    case ActionStateNone
    case ActionStateIdle
    case ActionStateAttack
    case ActionStateWalk
    case ActionStateHurt
}


class GameCharacter: NSObject {

    var sceneScene: SCNScene!
    var environmentScene: SCNScene!
    var characterNode: SCNNode!
    var nodes: Array<SCNNode>!
//    var walkAnimations = Array<CAAnimation>()
//    var idleAnimations = Array<CAAnimation>()
    var walkAnimations = [CAAnimation]()
    var idleAnimations = [CAAnimation]()
    
    var actionState: ActionState!
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
        
        actionState = .ActionStateNone
    }
    
    
    
    func setActionState(_ newState: ActionState)
    {
        switch newState {
        case .ActionStateIdle:
            if (actionState == newState)
            {}
            else
            {
                actionState = newState
                startIdleAnimationInScene(environmentScene)
            }
            break
        case .ActionStateWalk:
            if (actionState == newState)
            {}
            else
            {
                actionState = newState
                startWalkAnimationInScene(environmentScene)
            }
            break
        case .ActionStateNone:
            actionState = newState
            stopIdleAnimationInScene(environmentScene)
            stopWalkAnimationInScene(environmentScene)
            break
        default:
            actionState = newState
            stopIdleAnimationInScene(environmentScene)
            stopWalkAnimationInScene(environmentScene)
            break
        }
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
        actionState = .ActionStateWalk
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

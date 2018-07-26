//
//  Joystick.swift
//  xxk
//
//  Created by ReseBeta@WeShape on 2018/7/26.
//  Copyright © 2018年 xxk. All rights reserved.
//

import UIKit
import SpriteKit

class Joystick: SKNode {

    var thumbNode: SKSpriteNode!
    var isTracking: Bool!
    var velocity: CGPoint!
    var travelLimit: CGPoint!
    var angularVelocity: CGFloat!
    var size: CGFloat!
    
    var anchorPointInPoints: CGPoint!
    
    
//    init(aNode: SKSpriteNode)
//    {
//        velocity = CGPoint.zero
//        thumbNode = aNode
//        self.addChild(thumbNode)
//    }
//
//    func joystickWithThumb(aNode: SKSpriteNode) -> Any
//    {
//
//    }
//    func initWithThumb(aNode: SKSpriteNode, bgNode: SKSpriteNode) -> Any
//    {
////        bgNode.position =
//    }
    init(aNode: SKSpriteNode)
    {
        isUserInteractionEnabled = true
        velocity = CGPoint.zero
        thumbNode = aNode
        addChild(thumbNode)
    }
    init(aNode: SKSpriteNode, bgNode: SKSpriteNode)
    {
        bgNode.position = anchorPointInPoints
        size = bgNode.size.width
        addChild(bgNode)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let touchPoint = touch.location(in: self)
            
            if (isTracking == false && thumbNode.frame.contains(touchPoint))
            {
                isTracking = true
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let touchPoint = touch.location(in: self)
            
            if (isTracking == true && sqrtf(powf(Float(touchPoint.x - thumbNode.position.x), 2) + powf(Float(touchPoint.y - thumbNode.position.y), 2)) < size * 2)
            {
                if (sqrtf(powf(Float(touchPoint.x - anchorPointInPoints.x), 2) + powf(Float(touchPoint.y - anchorPointInPoints.y), 2)) <= thumbNode.size.width)
                {
                    let moveDifference = CGPoint(x: touchPoint.x - anchorPointInPoints.x, y: touchPoint.y - anchorPointInPoints.y)
                    thumbNode.position = CGPoint(x: anchorPointInPoints.x + moveDifference.x, y: anchorPointInPoints.y + moveDifference.y)
                }
                else
                {
//                    Double vX =
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        resetVelocity()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        resetVelocity()
    }
    
    func resetVelocity()
    {
        isTracking = false
        velocity = CGPoint.zero
        let easeOut = SKAction.move(to: anchorPointInPoints, duration: 0.3)
        easeOut.timingMode = .easeOut
        thumbNode.run(easeOut)
    }
}

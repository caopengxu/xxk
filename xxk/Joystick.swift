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
    var size: Float!
    
    var anchorPointInPoints: CGPoint = {
        let point = CGPoint(x: 0, y: 0)
        return point
    }()
    
    
    // 初始化
    init(aNode: SKSpriteNode)
    {
        super.init()
        
        self.isUserInteractionEnabled = true
        velocity = CGPoint.zero
        thumbNode = aNode
        self.addChild(thumbNode)
    }
    convenience init(aNode: SKSpriteNode, bgNode: SKSpriteNode)
    {
        self.init(aNode: aNode)
        bgNode.position = anchorPointInPoints
        size = Float(bgNode.size.width)
        self.addChild(bgNode)
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
                if (sqrtf(powf(Float(touchPoint.x - anchorPointInPoints.x), 2) + powf(Float(touchPoint.y - anchorPointInPoints.y), 2)) <= Float(thumbNode.size.width))
                {
                    let moveDifference = CGPoint(x: touchPoint.x - anchorPointInPoints.x, y: touchPoint.y - anchorPointInPoints.y)
                    thumbNode.position = CGPoint(x: anchorPointInPoints.x + moveDifference.x, y: anchorPointInPoints.y + moveDifference.y)
                }
                else
                {
                    let vX = touchPoint.x - anchorPointInPoints.x
                    let vY = touchPoint.y - anchorPointInPoints.y
                    let magV = sqrt(vX * vX + vY * vY)
                    let aX = anchorPointInPoints.x + vX / magV * thumbNode.size.width
                    let aY = anchorPointInPoints.y + vY / magV * thumbNode.size.width
                    thumbNode.position = CGPoint(x: aX, y: aY)
                }
            }
            
            velocity = CGPoint(x: thumbNode.position.x - self.anchorPointInPoints.x, y: thumbNode.position.y - anchorPointInPoints.y)
            angularVelocity = -atan2(thumbNode.position.x - anchorPointInPoints.x, thumbNode.position.y - anchorPointInPoints.y)
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

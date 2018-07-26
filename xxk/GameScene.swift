//
//  GameScene.swift
//  xxk
//
//  Created by ReseBeta@WeShape on 2018/7/26.
//  Copyright © 2018年 xxk. All rights reserved.
//

import UIKit
import SceneKit

class GameScene: SCNScene {
    
    var sceneView: SCNView!
    let cameraNode = SCNNode()
    
    
    func setupCamera()
    {
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 5)
        self.rootNode.addChildNode(cameraNode)
    }
    
    func setupSkyboxWithName(_ skybox: String, _ ext: String)
    {
        let right = skybox + "_right." + ext
        let left = skybox + "_left." + ext
        let top = skybox + "_top." + ext
        let bottom = skybox + "_bottom." + ext
        let front = skybox + "_front." + ext
        let back = skybox + "_back." + ext
        
        self.background.contents = [right, back, top, bottom, left, front]
    }
}

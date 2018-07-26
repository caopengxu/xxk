//
//  ViewController.swift
//  xxk
//
//  Created by ReseBeta@WeShape on 2018/7/26.
//  Copyright © 2018年 xxk. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class ViewController: UIViewController {
    
    @IBOutlet var scnView: SCNView!
    let scene = GameScene()
    
    var cameraNode: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.camera?.zFar = 1000
        node.position = SCNVector3(0, 100, 150)
        return node
    }()
    var animations: Array<Any>!
    var node: SCNNode!
    
    var overlay: SKScene!
    var walkAnimButton: SKSpriteNode!
    var cameraButton: SKSpriteNode!
    var wrenchButton: SKSpriteNode!
    var characterButton: SKSpriteNode!
    var characterPaths: Array<Any>!
    var currentCharacter: Int!
    
    var forwardDirectionVector: SCNVector3!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        sceneView.
        scene.rootNode.addChildNode(cameraNode)
        
        
        
        
        characterPaths = ["art.scnassets/Kakashi.dae", "Shisui", "Sasuke"];
        currentCharacter = 0
        
        
        scene.setupSkyboxWithName("sun1", "bmp")
        
        
        
        
    }


}


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
    var character: GameCharacter!
    
    var cameraNode: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.camera?.zFar = 1000
        node.position = SCNVector3(0, 100, 150)
        return node
    }()
    var lightNode: SCNNode = {
        let node = SCNNode()
        node.light = SCNLight()
        node.light?.type = .omni
        node.position = SCNVector3(0, 200, -100)
        return node
    }()
    var floorNode: SCNNode = {
        let floor = SCNFloor()
        floor.reflectivity = 0.0
        
        let floorNode = SCNNode(geometry: floor)

        let floorMaterial = SCNMaterial()
        floorMaterial.isLitPerPixel = false;
        floorMaterial.diffuse.contents = "art.scnassets/grass.jpg"
        floorMaterial.diffuse.wrapS = .repeat
        floorMaterial.diffuse.wrapT = .repeat
        floor.materials = [floorMaterial]
        
        return floorNode
    }()
    var ambientLightNode: SCNNode = {
        let node = SCNNode()
        node.light = SCNLight()
        node.light?.type = .ambient
        node.light?.color = UIColor.darkGray
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
    

    /// 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scnView.scene = scene
        
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(lightNode)
        scene.rootNode.addChildNode(floorNode)
        
        
        characterPaths = ["art.scnassets/Kakashi.dae", "Shisui", "Sasuke"];
        currentCharacter = 0
        
        
        scene.setupSkyboxWithName("sun1", "bmp")
        
        
        setupCharacter()
        character.characterNode.position = SCNVector3(0, 0, -250)
        character.characterNode.rotation = SCNVector4(0, 1, 0, CGFloat.pi)
        
        
        setupHUD()
    }

    
    func setupCharacter()
    {
        var character = GameCharacter(scene: SCNScene(named: "art.scnassets/Kakashi.dae")!, name: "SpongeBob")
        character.environmentScene = scene
        scene.rootNode.addChildNode(character.characterNode)
        
        
        let url = Bundle.main.url(forResource: "art.scnassets/Kakashi(walking)", withExtension: "dae")
        let sceneSource = SCNSceneSource(url: url!, options: nil)
        
//        let animationIds = sceneSource?.identifiersOfEntries(withClass: <#T##AnyClass#>)
//
//        for eachId in animationIds
//        {
//            let animation = sceneSource?.entryWithIdentifier(eachId, withClass: <#T##T.Type#>)
//
//        }
        
//        let animations = Array
        
    }
    
    
    
    func setupHUD()
    {
        let screenSize = UIScreen.main.bounds.size
        
        overlay = SKScene(size: scnView.bounds.size)
        overlay.scaleMode = .aspectFill
        scnView.overlaySKScene = overlay
        
        
        walkAnimButton = SKSpriteNode(imageNamed: "walking")
        walkAnimButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        walkAnimButton.size = CGSize(width: 32, height: 32)
        walkAnimButton.position = CGPoint(x: screenSize.width - walkAnimButton.size.width, y: screenSize.height - walkAnimButton.size.height)
        walkAnimButton.name = "WalkAnimationButton"
        
        
        cameraButton = SKSpriteNode(imageNamed: "camera")
        cameraButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        cameraButton.size = CGSize(width: 32, height: 32)
        cameraButton.position = CGPoint(x: screenSize.width - walkAnimButton.size.width - 15 - cameraButton.size.width, y: screenSize.height - cameraButton.size.height)
        cameraButton.name = "CameraButton"
        overlay.addChild(cameraButton)
        
        
        wrenchButton = SKSpriteNode(imageNamed: "wrench")
        wrenchButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        wrenchButton.size = CGSize(width: 32, height: 32)
        wrenchButton.position = CGPoint(x: screenSize.width - wrenchButton.size.width, y: screenSize.height - wrenchButton.size.height)
        wrenchButton.name = "WrenchButton"
        overlay.addChild(wrenchButton)
        
        
        characterButton = SKSpriteNode(imageNamed: "group")
        characterButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        characterButton.size = CGSize(width: 32, height: 32)
        characterButton.position = CGPoint(x: screenSize.width - characterButton.size.width, y: screenSize.height - characterButton.size.height)
        characterButton.name = "CharacterButton"
        overlay.addChild(characterButton)
        
        
        let jsThumb = SKSpriteNode(imageNamed: "joystick")
        let jsBackdrop = SKSpriteNode(imageNamed: "dpad")
        move
    }

}


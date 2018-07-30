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
    var scene: GameScene!
    var character: GameCharacter!
    
    var cameraNode: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.camera?.zFar = 1000
        node.position = SCNVector3(0, 100, 150)
        return node
    }()
    var pointLightNode: SCNNode = {
        let node = SCNNode()
        node.light = SCNLight()
        node.light?.type = .omni
        node.position = SCNVector3(0, 200, -100)
        return node
    }()
    var ambientLightNode: SCNNode = {
        let node = SCNNode()
        node.light = SCNLight()
        node.light?.type = .ambient
        node.light?.color = UIColor.darkGray
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
    
    var animations: [CAAnimation] = {
        let array = [CAAnimation]()
        return array
    }()
//    var animations: Array<CAAnimation> = {
//        let array = Array<CAAnimation>()
//        return array
//    }()
    var node: SCNNode!
    
    var overlay: SKScene!
    var movementJoystick: Joystick!
    var walkAnimButton: SKSpriteNode!
    var cameraButton: SKSpriteNode!
    var wrenchButton: SKSpriteNode!
    var characterButton: SKSpriteNode!
    
    var characterPaths: Array<String> = {
        let array = ["art.scnassets/Kakashi.dae", "Shisui", "Sasuke"]
        return array
    }()
    var currentCharacter: Int = 0
    
    var forwardDirectionVector: SCNVector3!
    var shouldStop: Bool!
    

    /// 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = GameScene(view: scnView)
        scene.setupSkyboxWithName("sun1", "bmp")
        
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(pointLightNode)
        scene.rootNode.addChildNode(ambientLightNode)
        
        setupCharacter()
        character.characterNode.position = SCNVector3(0, 0, -250)
        character.characterNode.rotation = SCNVector4(0, 1, 0, CGFloat.pi)
        
        scene.rootNode.addChildNode(floorNode)
        
        scnView.scene = scene
        setupHUD()
    }

    
    func setupCharacter()
    {
        character = GameCharacter(scene: SCNScene(named: "art.scnassets/Kakashi.dae")!, name: "SpongeBob")
        character.environmentScene = scene
        scene.rootNode.addChildNode(character.characterNode)
        
        
        let url = Bundle.main.url(forResource: "art.scnassets/Kakashi(walking)", withExtension: "dae")
        let sceneSource = SCNSceneSource(url: url!, options: nil)
        let animationIds = sceneSource?.identifiersOfEntries(withClass: CAAnimation.self)
        for eachId in animationIds!
        {
            let animation = sceneSource?.entryWithIdentifier(eachId, withClass: CAAnimation.self)
            character.walkAnimations.append(animation!)
        }
        
        
        let url2 = Bundle.main.url(forResource: "art.scnassets/Kakashi(idle)", withExtension: "dae")
        let sceneSource2 = SCNSceneSource(url: url2!, options: nil)
        let animationIds2 = sceneSource2?.identifiersOfEntries(withClass: CAAnimation.self)
        for eachId in animationIds2!
        {
            let animation = sceneSource2?.entryWithIdentifier(eachId, withClass: CAAnimation.self)
            character.idleAnimations.append(animation!)
        }
        
        character.actionState = .actionStateIdle
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
        movementJoystick = Joystick(aNode: jsThumb, bgNode: jsBackdrop)
        movementJoystick.position = CGPoint(x: jsBackdrop.size.width / 1.5, y: jsBackdrop.size.height / 1.5)
        overlay.addChild(movementJoystick)
    }
    
    
    func setCharacterFromModelWithName(name: String)
    {
        let postion = character.characterNode.position
        let rotation = character.characterNode.rotation
        character.characterNode.removeFromParentNode()
        
        character = GameCharacter(scene: SCNScene(named: name)!, name: "")
        character.environmentScene = scene
        scene.rootNode.addChildNode(character.characterNode)
        
        let url = Bundle.main.url(forResource: "art.scnassets/Kakashi(walking)", withExtension: "dae")
        let sceneSource = SCNSceneSource(url: url!, options: nil)
        let animationIds = sceneSource?.identifiersOfEntries(withClass: CAAnimation.self)
        for eachId in animationIds!
        {
            let animation = sceneSource?.entryWithIdentifier(eachId, withClass: CAAnimation.self)
            animations.append(animation!)
        }
        character.walkAnimations = NSArray(array: animations) as! [CAAnimation]
        
        
        let url2 = Bundle.main.url(forResource: "art.scnassets/Kakashi(idle)", withExtension: "dae")
        let sceneSource2 = SCNSceneSource(url: url2!, options: nil)
        let animationIds2 = sceneSource2?.identifiersOfEntries(withClass: CAAnimation.self)
        for eachId in animationIds2!
        {
            let animation = sceneSource2?.entryWithIdentifier(eachId, withClass: CAAnimation.self)
            animations.append(animation!)
        }
        character.idleAnimations = NSArray(array: animations) as! [CAAnimation]
        
        
        character.actionState = .actionStateIdle
        character.startIdleAnimationInScene(character.environmentScene)
        
        
        character.characterNode.position = postion
        character.characterNode.rotation = rotation
    }
    
    
    func tap()
    {
        if (!shouldStop)
        {
            character.startWalkAnimationInScene(scene)
        }
        else
        {
            character.stopWalkAnimationInScene(scene)
        }
        shouldStop = !shouldStop
    }
    
    
    // MARK: === touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.randomElement()!
        let location = touch.location(in: overlay)
        let touchedNodes = overlay.nodes(at: location)
        
        for touchedNode in touchedNodes
        {
            if (touchedNode.name == "WalkAnimationButton")
            {
                tap()
            }
            else if (touchedNode.name == "CameraButton")
            {
                scnView.allowsCameraControl = true
            }
            else if (touchedNode.name == "WrenchButton")
            {
                scnView.showsStatistics = true
            }
            else if (touchedNode.name == "CharacterButton")
            {
                if (currentCharacter < characterPaths.count - 1)
                {
                    currentCharacter += 1
                }
                else
                {
                    currentCharacter = 0
                }
                
                setCharacterFromModelWithName(name: characterPaths[currentCharacter])
            }
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { (context) in
            
            if (size.width > size.height)
            {}
            else
            {}
            self.overlay.removeAllChildren()
            self.setupHUD()
        }
    }
    
    
    func rotateVector3(vector: SCNVector3, axis: Int, angle: CGFloat) -> SCNVector3
    {
        let angle = Float(angle)
        
        if (axis == 1)
        {
            let result = SCNVector3(cosf(angle) * vector.x + sinf(angle) * vector.z, vector.y, -sinf(angle) * vector.x + cosf(angle) * vector.z)
            return result
        }
        else
        {
            return SCNVector3Zero
        }
    }
}


extension ViewController: SCNSceneRendererDelegate
{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    {
        if (movementJoystick.velocity.x != 0 || movementJoystick.velocity.y != 0)
        {
            character.actionState = .actionStateWalk
            
            let angleDegrees = movementJoystick.angularVelocity * 57.3
            
            if (angleDegrees >= 0 && angleDegrees <= 90)
            {
                print("TL")
            }
            else if (angleDegrees > 90 && angleDegrees <= 179)
            {
                print("BL")
            }
            else if (angleDegrees < 0 && angleDegrees >= -90)
            {
                print("TR")
            }
            else if (angleDegrees < -90 && angleDegrees <= 179)
            {
                print("BR")
            }
            
            forwardDirectionVector = SCNVector3(0, 0, 1)
            forwardDirectionVector = rotateVector3(vector: forwardDirectionVector, axis: 1, angle: movementJoystick!.angularVelocity)
            
            character.characterNode.position = SCNVector3(character.characterNode.position.x - forwardDirectionVector.x * 5, character.characterNode.position.y + forwardDirectionVector.y * 5, character.characterNode.position.z - forwardDirectionVector.z * 5)
            cameraNode.position = SCNVector3(cameraNode.position.x - forwardDirectionVector.x * 5, cameraNode.position.y + forwardDirectionVector.y * 5, cameraNode.position.z - forwardDirectionVector.z * 5)
            
            character.characterNode.rotation = SCNVector4(0, 1, 0, .pi + movementJoystick.angularVelocity)
        }
        else
        {
            character.actionState = .actionStateIdle
        }
    }
}

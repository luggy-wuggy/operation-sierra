//
//  GameScene.swift
//  shadedProject
//
//  Created by Luqman Abdurrohman on 10/7/19.
//  Copyright © 2019 Luqman Abdurrohman. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var platform = SKShapeNode()
    
    
    override func didMove(to view: SKView) {
        setupPlayerAndObstacle()
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
        
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        platform = SKShapeNode.init(rectOf: CGSize.init(width: 200, height: 30))
        platform.position = CGPoint(x: 0,  y: -570)
        platform.fillColor = SKColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        platform.strokeColor = SKColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        
        platform.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 30))
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.allowsRotation = false
        platform.physicsBody?.pinned = false
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.friction = 0.0
        platform.physicsBody?.restitution = 0.0 //BOUNCYINESS
        platform.physicsBody?.linearDamping = 0.1
        platform.physicsBody?.angularDamping = 0.1
        
        platform.physicsBody?.categoryBitMask = 1
        platform.physicsBody?.collisionBitMask = 2
        platform.physicsBody?.fieldBitMask = 0
        platform.physicsBody?.contactTestBitMask = 2
        
        self.addChild(platform)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    func setupPlayerAndObstacle(){
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addObstacle), SKAction.wait(forDuration: 0.75)])))
    }
    
    func addObstacle(){
        
        //Calls the RGB function and assigns RGB values to variables rgbNormal and rgbTarget(the different shaded color)
        //rgbPackage is an array of an array of CGFloat
        //rgbNormal and rgbTarget is an array of CGFloat (values for RGB)
        let rgbPackage = createRGB_Values()
        let rgbNormal = rgbPackage[0]
        let rgbTarget = rgbPackage[1]

        let positionObjects : [CGFloat] = [-250, (frame.midX), 250]         // : an array for the X positions for the shapes
        let shadedPositionRandomizer : Int = Int.random(in: 0 ... 2)       // : a randomizer for the position of the different shaded object

        //for loop to create 3 instances of shapes, the circleNumber attributes to the location of the object
        for circleNumber in 0 ... 2{
            let objectRandomizer : Int = Int.random(in: 0 ... 1)    // : a randomizer for the type of shape to create
            
            if circleNumber == shadedPositionRandomizer{ // if statement: creates the object with the different shade at the randomized location
                addCircleObstacle(xPosition: positionObjects[circleNumber], yPosition: 800, rgbValue: rgbTarget, shape: objectRandomizer)
                
            }
            else{ // else statement: creates the rest of the "normal" shaded object
                addCircleObstacle(xPosition: positionObjects[circleNumber], yPosition: 800, rgbValue: rgbNormal, shape: objectRandomizer)
            }
        }
        
    }
    
    // A function that creates ONE object, with parameters that determines the
    // positioning (CGFloat) , color(CGFloat Array), and shape(int)
    func addCircleObstacle(xPosition: CGFloat, yPosition : CGFloat, rgbValue: Array<CGFloat>, shape: Int){
        
        //Globabl variables of type Shape Node and Physics Body
        //Assigned values distinguished by the shape given
        var Object = SKShapeNode()
        var Physics = SKPhysicsBody()
        
        //Assigns the shape values determined by the parameters given (shape : Int)
        //(0 = circle, 1 = square)
        if shape == 0{
            Object = SKShapeNode(circleOfRadius: 85)
            Physics = SKPhysicsBody(circleOfRadius: 85)
        }
        else if shape == 1{
            Object = SKShapeNode(rectOf: CGSize(width: 170, height: 170), cornerRadius: 15)
            Physics = SKPhysicsBody(rectangleOf: CGSize(width: 170, height: 170))
        }
        
        //Declaration of the positioning and color of the shape
        let ShapeObject = Object
        ShapeObject.position = CGPoint(x: xPosition , y: yPosition)
        ShapeObject.strokeColor = SKColor.init(red: rgbValue[0], green: rgbValue[1], blue: rgbValue[2], alpha: 1)
        //ShapeObject.fillColor = SKColor.init(red: rgbValue[0], green: rgbValue[1], blue: rgbValue[2], alpha: 1)
        ShapeObject.glowWidth = 1.0
        ShapeObject.lineWidth = 15
        self.addChild(ShapeObject)
        
        //Declaration of the physics applied to the shape
        ShapeObject.physicsBody = Physics
        ShapeObject.physicsBody?.isDynamic = true
        ShapeObject.physicsBody?.allowsRotation = false
        ShapeObject.physicsBody?.pinned = false
        ShapeObject.physicsBody?.affectedByGravity = true
        ShapeObject.physicsBody?.friction = 0.0
        ShapeObject.physicsBody?.restitution = 3.8 //BOUNCYINESS
        ShapeObject.physicsBody?.linearDamping = 0
        ShapeObject.physicsBody?.angularDamping = 0
        
        //Declaration of the grouping of physics (involving collisions with other objects)
        ShapeObject.physicsBody?.categoryBitMask = 2
        ShapeObject.physicsBody?.collisionBitMask = 1
        ShapeObject.physicsBody?.fieldBitMask = 0
        ShapeObject.physicsBody?.contactTestBitMask = 1
        
        //If the shape is square (or 1) then applies rotation
        if shape == 1{
            let rotationRandomizer : Int = Int.random(in: 0 ... 1)
            var rotate = SKAction()
            
            //Randomizes whether square rotates clockwise or counter clockwise
            if rotationRandomizer == 0 {
                rotate = SKAction.rotate(byAngle: 2.0 * CGFloat(-Double.pi), duration: 3.5)
            }else{
                rotate = SKAction.rotate(byAngle: 2.0 * CGFloat(Double.pi), duration: 3.5)
            }
            
            ShapeObject.run(SKAction.repeatForever((rotate)))
        }

        //Action for the movement of the object from top to bottom of the screen
        //Also removes the shape node once it reaches the bottom.
        let moveVertically = SKAction.moveTo(y: -750, duration: Double(2))
        let removeNode = SKAction.removeFromParent()
        let gravity = SKAction.sequence([moveVertically, removeNode])
        
        ShapeObject.run(gravity)
        

    }
    
    // A function that returns an array of size two with the element being an array of CGFloats
    // For example: [ [0.7, 0.3, 0.5], [0.8, 0.4, 0.6] ]
    func createRGB_Values() -> [Array<CGFloat>] {
        
        // rgbValues: Declares an array of CGFloat between 0 ... 1 to denote RGB values
        // rgbValues_Target: Declares an array of CGFloat using the values from rgbValues array
        let rgbValues: [CGFloat] = [CGFloat.random(in: 0.00 ... 1.00), CGFloat.random(in: 0.00 ... 1.00), CGFloat.random(in: 0.00 ... 1.00)]
        var rgbValues_Target: [CGFloat] = [0.0,0.0,0.0] //
        
        for color in 0...2{
            var newColorValue = rgbValues[color] + 0.10
            if newColorValue > 1.0{
                newColorValue = rgbValues[color]
            }
            rgbValues_Target[color] = newColorValue
        }
        
        let rgbPackage = [rgbValues, rgbValues_Target]
        
        return rgbPackage
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches {
            let location = t.location(in: self)
            
            platform.run(SKAction.moveTo(x: location.x, duration: 0.2))
            
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            
            let location = t.location(in: self)
            
            platform.run(SKAction.moveTo(x: location.x, duration: 0.2))
            
        }
    }
    

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

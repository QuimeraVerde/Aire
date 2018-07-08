//
//  Pm10.swift
//  Aire
//
//  Created by Pau Escalante on 7/2/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import ARKit

class PollutantModel: SCNNode {
    
    // rotation for pollutants
    let kRotationRadianPerLoop: CGFloat = CGFloat(Float.pi)
    let kAnimationDurationMoving: TimeInterval = 5
    
    // At least these n individual pollutants should be close to viewer
    let nCloseObjects: Int = 20
    
    // radius for normal proximity
    let xRadius: Float = 4
    let yRadius: Float = 3
    let zRadius: Float = 4
    
    // radius for close proximity
    let xNearRadius: Float = 1
    let yNearRadius: Float = 1
    let zNearRadius: Float = 2
    
    override init(){
        super.init()
        self.opacity = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadModel(modelName: String){
        guard let virtualObjectScene = SCNScene(named: modelName + ".scn") else { return }
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        addChildNode(wrapperNode)
    }
    
    func fadeInAction(){
        if self.opacity == 0.0 {
            runAction(SCNAction.fadeIn(duration: 0.5))
        }
    }
    
    func fadeOutAction(){
        if self.opacity == 1.0 {
            runAction(SCNAction.fadeOut(duration: 0.5))
        }
    }
    
    func animate(objectCount: Int) {
        // rotate pollutant node
        // 0 not rotating on axis
        // -1 is to left
        // 1 to the right
        // randomizing with the index value and random number
        let randomNumber = Int(arc4random_uniform(9) + 1)
        
        let yRotation = (randomNumber % 2 == 0) ? -1 : 1
        let xRotation = (objectCount % 2 == 0) ? -1 : 1
        
        rotatePollutant(yRotationDirection: CGFloat(yRotation),
                        xRotationDirection: CGFloat(xRotation))
    }
    
    func randomPosition(objectCount: Int){
        
        // first objects should be at proximity of viewer
        if (objectCount < nCloseObjects) {
            // set the node position according to index of object
            position = generateCloseVector(count:objectCount)
        }
        else {
            // set the node position according to index of object
            position = generateRandomVector(count:objectCount)
        }
    }
    
    // rotate in axis
    func rotatePollutant(yRotationDirection: CGFloat, xRotationDirection: CGFloat){
        // rotate on euler
        eulerAngles = SCNVector3((eulerAngles.x * Float(xRotationDirection)),
                                 (eulerAngles.y * Float(yRotationDirection)),
                                 eulerAngles.x)
        
        let actionRotate = SCNAction.rotateBy(x: (xRotationDirection*kRotationRadianPerLoop),
                                        y: (yRotationDirection*kRotationRadianPerLoop),
                                        z: 0, duration: kAnimationDurationMoving)
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.02, z: 0, duration: 2.5)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.02, z: 0, duration: 2.5)
        
        
        let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let rotateAndHover = SCNAction.group([actionRotate, hoverSequence])
        
        let loopAction = SCNAction.repeatForever(rotateAndHover)
        
        let randomDelay: Int = Int(Float.random(min: 0.00, max: 1.50) * 1000)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(randomDelay), execute: {
            self.runAction(loopAction)
        })
    }
    
    func addLabel(){
        
    }
    
    func generateRandomVector(count: Int) -> SCNVector3 {
        // create random distance for normal radius
        let randomX = Float.random(min: -(xRadius), max: xRadius)
        let randomY = Float.random(min: -(yRadius), max: yRadius)
        let randomZ = Float.random(min: -(zRadius), max: zRadius)
        let randomVector =  SCNVector3(randomX, randomY, randomZ)
        
        return randomVector
    }
    
    func generateCloseVector(count: Int) -> SCNVector3 {
        // create random distance for radius close to viewer
        let randomX = Float.random(min: -(xNearRadius), max: xNearRadius)
        let randomY = Float.random(min: -(yNearRadius), max: yNearRadius)
        let randomZ = Float.random(min: -(zNearRadius), max: zNearRadius)
        let randomVector =  SCNVector3(randomX, randomY, randomZ)
        
        return randomVector
    }
}

// randomizer
public extension Float {
    
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    
    public static var random:Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    /*
     Create a random num Float
     
     - parameter min: Float
     - parameter max: Float
     
     - returns: Float
     */
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}

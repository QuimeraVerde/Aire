//
//  SCNNodeAnimation.swift
//  Aire
//
//  Created by Natalia García on 8/17/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import ARKit

struct SCNNodeAnimation {
	
	static func fadeIn(_ node: SCNNode) {
		if node.opacity == 0.0 {
			node.runAction(SCNAction.fadeIn(duration: 0.5))
		}
	}
	
	static func fadeOut(_ node: SCNNode) {
		if node.opacity == 1.0 {
			node.runAction(SCNAction.fadeOut(duration: 0.5))
		}
	}
	
	static func pulse(node: SCNNode){
		let prevScale = node.scale
		node.scale = SCNVector3(0.01, 0.01, 0.01)
		
		let scaleAction = SCNAction.scale(to: CGFloat(prevScale.x), duration: 0.5)
		scaleAction.timingMode = .linear
		
		// Use a custom timing function
		scaleAction.timingFunction = { (p: Float) in
			return self.easeOutElastic(p)
		}
		
		node.runAction(scaleAction, forKey: "scaleAction")
	}
	
	// timing function
	private static func easeOutElastic(_ t: Float) -> Float {
		let p: Float = 0.3
		let newValue: Float = ( t - p )
		let sinValue: Float = ( newValue / 4.0) * (2.0 * Float.pi) / p
		let result = pow(2.0, -10.0 * t) * sin(sinValue) + 1.0
		return result
	}
	
	static func rotateRandomly(_ node: SCNNode) {
		// 0 not rotating on axis
		// -1 is to left
		// 1 to the right
		// seeds for randomizing: time since 1970 and random number
		let timeSince1970 = Int(Date().timeIntervalSince1970)
		let randomNumber = Int(arc4random_uniform(9) + 1)
		
		let xRotation = (timeSince1970 % 2 == 0) ? -1 : 1
		let yRotation = (randomNumber % 2 == 0) ? -1 : 1
		
		self.rotate(node, yRotationDirection: CGFloat(yRotation),
						xRotationDirection: CGFloat(xRotation))
	}
	
	// rotate in axis
	private static func rotate(_ node: SCNNode, yRotationDirection: CGFloat, xRotationDirection: CGFloat){
		// rotate on euler
		node.eulerAngles = SCNVector3((node.eulerAngles.x * Float(xRotationDirection)),
								 (node.eulerAngles.y * Float(yRotationDirection)),
								 node.eulerAngles.x)
		
		let kRotationRadianPerLoop: CGFloat = CGFloat(Float.pi)
		let kAnimationDurationMoving: TimeInterval = 5
		
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
			node.runAction(loopAction)
		})
	}
    
    
}

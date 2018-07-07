//
//  PollutantLabel.swift
//  Aire
//
//  Created by Pau Escalante on 7/3/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import ARKit

class PollutantLabel: SCNNode {
	
	// rotation for pollutants
	let kRotationRadianPerLoop: CGFloat = 0.2
	let kAnimationDurationMoving: TimeInterval = 0.2
	
    func loadModel(text: String, fontSize: CGFloat, title: String){
        // text
        let textLabel = SCNText(string: text, extrusionDepth: 0.4)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        material.lightingModel = SCNMaterial.LightingModel.phong
        textLabel.materials = [material]
        textLabel.flatness = 0
        textLabel.font = UIFont(name:"Avenir-Roman", size: fontSize)
        textLabel.name = title
        
        // node to handle text
        let wrapperNode = SCNNode()
        wrapperNode.name = "label"
        wrapperNode.geometry = textLabel
        addChildNode(wrapperNode)
    }
	
	func positionLabel(node: SCNNode, yOffset: Float){
		// set position
		position = SCNVector3Make(node.worldPosition.x,
								  (node.worldPosition.y + yOffset),
								  node.worldPosition.z)
		scale = node.scale
		rotateLabel()
	}
	
	// rotate in axis
	func rotateLabel(){
		// setup pivot
		let (minVec, maxVec) = boundingBox
		pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0)
		
		let action = SCNAction.rotateBy(x: 0,
										y: kRotationRadianPerLoop,
										z: 0, duration: kAnimationDurationMoving)
		
		let loopAction = SCNAction.repeatForever(action)
		runAction(loopAction)
	}
}

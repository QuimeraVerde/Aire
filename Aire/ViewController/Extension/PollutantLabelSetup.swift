//
//  PollutantLabelSetup.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension ViewController {	
	func showLabel(pollutantKey: String, node: SCNNode){
		let pollutantLabel = PollutantLabel()
		var pollutantText: String = ""
		var pollutantTitle: String = ""
		var pollutantYOffset: Float = 0.0
		var pollutantFont: Float = 0.0
		
		// if key is found
		if (PollutantUtility.config.model[pollutantKey] != nil) {
			// remove other labels
			cleanseLabels()
			
			let pollutantConfig: ModelConfiguration = PollutantUtility.config.model[pollutantKey]!
			
			pollutantText = pollutantConfig.text
			pollutantYOffset = pollutantConfig.yOffset
			pollutantFont = pollutantConfig.fontSize
			pollutantTitle = pollutantConfig.title
			
			// create label model
			pollutantLabel.loadModel(text:pollutantText, fontSize: CGFloat(pollutantFont), title: pollutantTitle)
			sceneView.scene.rootNode.addChildNode(pollutantLabel)
			
			// identifier for cleaning labels
			pollutantLabel.name = "label"
			
			// position label on top of model
			pollutantLabel.positionLabel(node:node, yOffset: pollutantYOffset)
		}
	}
	
	// remove all labels from scene view
	func cleanseLabels(){
		sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
			if node.name == "label" {
				node.removeFromParentNode()
			}
		}
	}
}

//
//  Scene.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension ViewController {

	func addTapGesture() {
		//Create TapGesture Recognizer
		let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(rec:)))
		singleTap.numberOfTapsRequired = 1
		
		//Create TapGesture Recognizer
		let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(rec:)))
		doubleTap.numberOfTapsRequired = 2
		
		//Add recognizer to sceneview
		sceneView.addGestureRecognizer(singleTap)
		sceneView.addGestureRecognizer(doubleTap)
		singleTap.require(toFail: doubleTap)
	}
	
	//Method called when single tap
	@objc func handleSingleTap(rec: UITapGestureRecognizer){
		if rec.state == .ended {
			let location: CGPoint = rec.location(in: sceneView)
			let hits = self.sceneView.hitTest(location, options: nil)
			if !hits.isEmpty{
				let tappedNode = hits.first?.node
				handleTapSingleNode(node:tappedNode!)
			}
		}
	}
	
	//Method called when double tap
	@objc func handleDoubleTap(rec: UITapGestureRecognizer){
		if rec.state == .ended {
			let location: CGPoint = rec.location(in: sceneView)
			let hits = self.sceneView.hitTest(location, options: nil)
			if !hits.isEmpty{
				let tappedNode = hits.first?.node
				// show label the same as a single tap
				handleTapSingleNode(node:tappedNode!)
				
				// show card as shortcut
				showPollutantInfo(pollutantName: getNodePollutantName(node: tappedNode!))
			}
		}
	}
	
	func handleTapSingleNode(node: SCNNode){
		// animate tap
		animateTap(node:node)
		
		// grab name of node for identification purposes
		let nodeName: String = node.name ?? "none"
		
		if (nodeName == "label") {
			// show info card for pollutant, name of pollutant in geometry
			let pollutantId = node.geometry?.name ?? "none"
			showPollutantInfo(pollutantName: pollutantId)
		}
			
		else {
			// hide card
			hideCard()
			
			// show label for pollutant
			showLabel(pollutantKey: nodeName, node: node)
		}
	}
	
	func animateTap(node: SCNNode){
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
	func easeOutElastic(_ t: Float) -> Float {
		let p: Float = 0.3
		let newValue: Float = ( t - p )
		let sinValue: Float = ( newValue / 4.0) * (2.0 * Float.pi) / p
		let result = pow(2.0, -10.0 * t) * sin(sinValue) + 1.0
		return result
	}
	
	// creates multiple nodes
	func createPollutants(pollutants: Dictionary<String,Pollutant>){
		
		// iterate through dictionary of pollutants
		for (key, value) in pollutants {
			// make sure there is data in pollutant
			if (value.count > 0){
				
				// iterate through count of pollutants to add them to sceneview
				for i in 1...value.count {
					addPollutant(pollutantModelName: key, index:i)
				}
			}
		}
	}
	
	// add individual node pollutant
	func addPollutant(pollutantModelName: String, index: Int) {
		let pollutantModel = PollutantModel()
		pollutantModel.loadModel(modelName:pollutantModelName)
		sceneView.scene.rootNode.addChildNode(pollutantModel)
		
		// animate pollutant
		pollutantModel.animate(objectCount:index)
		
		// randomize position
		pollutantModel.randomPosition(objectCount:index)
	}
	
	// shortcuts to getting the pollutant name that is hidden
	func getNodePollutantName(node: SCNNode) -> String{
		// grab name of node for identification purposes
		let nodeName: String = node.name ?? "none"
		
		// check if label
		if (nodeName == "label") {
			return node.geometry?.name ?? "none"
		}
		
		return nodeName
	}
}

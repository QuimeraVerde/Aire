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
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            handleShakeGesture()
        }
    }
	
    func handleShakeGesture(){
        removePollutants()
        //hideCard()
		self.pollutantCardView.hide()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(500), execute: {
                self.createPollutants(pollutants: self.pollutantsInfo, dominant: self.dominantPollutant)
        })
    }
    
    @IBAction func ViewAqiReport(_ sender: UIButton) {
        // if any was visible
        //hideCard()
		self.pollutantCardView.hide()
        self.fullReportAlert.show()
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
				self.pollutantCardView.update(pollutant: getNodePollutant(node: tappedNode!))
				self.pollutantCardView.show()
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
			//let pollutantId = node.geometry?.name ?? "none"
			let pollutantId = PollutantIdentifier(rawValue: node.geometry?.name ?? "none")
			//showPollutantInfo(pollutantName: pollutantId)
			if let pollutant = self.pollutantsInfo[pollutantId!] {
				self.pollutantCardView.update(pollutant: pollutant)
				self.pollutantCardView.show()
			}
		}
			
		else {
			// hide card
			self.pollutantCardView.hide()
			
			// show label for pollutant
			showLabel(pollutantTitle: nodeName, node: node)
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
}

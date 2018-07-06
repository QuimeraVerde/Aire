//
//  SceneSetup.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension ViewController {
	func setupScene() {
		let scene = SCNScene()
		sceneView.scene = scene
		sceneView.autoenablesDefaultLighting = false
	}
	
	func setupARConfiguration() {
		let configuration = ARWorldTrackingConfiguration()
		configuration.isLightEstimationEnabled = true
		sceneView.session.run(configuration)
		
		addTapGesture()
	}
}

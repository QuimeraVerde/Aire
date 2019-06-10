//
//  SceneSession.swift
//  
//
//  Created by Natalia García on 6/9/19.
//

import ARKit
import RxSwift

protocol PollutantUpdaterDelegate {
	func outOfFrame(pollutant: PollutantModel)
}

class AireSceneView: ARSCNView, ARSessionDelegate, PollutantUpdaterDelegate {
	var variable: Variable<SCNNode> = Variable(SCNNode())
	var observable: Observable<SCNNode> {
		return self.variable.asObservable()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		sharedInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		sharedInit()
	}
	
	func sharedInit() {
		if let pov = self.pointOfView {
			self.variable.value = pov
		}
		self.session.delegate = self
	}
	
	func session(_ session: ARSession, didUpdate frame: ARFrame) {
		if let pov = self.pointOfView {
			self.variable.value = pov
		}
	}
	
	func outOfFrame(pollutant: PollutantModel) {
		if let pov = self.pointOfView {
			pollutant.setPositionInPointOfView(pointOfView: pov)
		}
	}
}

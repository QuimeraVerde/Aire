//
//  Pm10.swift
//  Aire
//
//  Created by Pau Escalante on 7/2/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import ARKit
import RxSwift

class PollutantModel: SCNNode {
	let disposeBag: DisposeBag = DisposeBag()
	var delegate: PollutantUpdaterDelegate?
	var sceneView: ARSCNView?
	
    override init() {
        super.init()
        self.sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
		super.init()
        self.sharedInit()
    }
	
	private func sharedInit() {
		self.opacity = 0.0
	}

	func subscribe(pointOfView: Observable<SCNNode>) {
		pointOfView.bind(onNext: { pov in
			if (!self.inFrustum(pov)) {
				if let d = self.delegate {
					d.outOfFrame(pollutant: self)
				}
			}
		}).disposed(by: self.disposeBag)
	}
	
	func inFrustum(_ pointOfView: SCNNode) -> Bool {
		if let s = self.sceneView {
			return s.isNode(self, insideFrustumOf: pointOfView)
		}
		return false
	}
    
    func loadModel(modelID: PollutantIdentifier){
        let wrapperNode = PollutantCache.shared.getSceneNode(id: modelID) ?? PollutantCache.shared.setSceneNode(id: modelID)
        
        self.addChildNode(wrapperNode.clone())
    }
	
	func setPositionInPointOfView(pointOfView: SCNNode) {
		let localPosition = generateRandomVector(xRadius: 1, yRadius: 1, zRadius: 2)
		let scenePosition = pointOfView.convertPosition(localPosition, to: nil)
		// to: nil is automatically scene space
		self.position = scenePosition
	}

	func setPositionNear() {
		self.position = generateRandomVector(xRadius: 1, yRadius: 1, zRadius: 2)
	}
	
	func setPositionAnywhere() {
		self.position = generateRandomVector(xRadius: 4, yRadius: 3, zRadius: 4)
	}
	
	private func generateRandomVector(xRadius: Float, yRadius: Float, zRadius: Float) -> SCNVector3 {
        let randomX = Float.random(min: -(xRadius), max: xRadius)
        let randomY = Float.random(min: -(yRadius), max: yRadius)
        let randomZ = Float.random(min: -(zRadius), max: zRadius)
        let randomVector =  SCNVector3(randomX, randomY, randomZ)
        
        return randomVector
    }
}

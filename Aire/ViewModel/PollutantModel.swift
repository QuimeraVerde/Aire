//
//  Pm10.swift
//  Aire
//
//  Created by Pau Escalante on 7/2/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import ARKit

class PollutantModel: SCNNode {
    override init(){
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
    
    func loadModel(modelID: PollutantIdentifier){
        guard let virtualObjectScene = SCNScene(named: modelID.rawValue + ".scn") else { return }
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        wrapperNode.name = modelID.rawValue
        self.addChildNode(wrapperNode)
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

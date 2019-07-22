//
//  Pm10.swift
//  Aire
//
//  Created by Pau Escalante on 7/2/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import ARKit

class PollutantModel: SCNNode {
    let nearXRadius: Float = 1
    let nearYRadius: Float = 1
    let nearZRadius: Float = 2
    let regularXRadius: Float = 4
    let regularYRadius: Float = 3
    let regularZRadius: Float = 4
    let patrolDistanceNear: Float = 0.3
    let patrolDistanceFar: Float = 0.35
    var labelVisible = false
    
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
		self.position = generateRandomVector(xRadius: nearXRadius, yRadius: nearYRadius, zRadius: nearZRadius)
	}
	
	func setPositionAnywhere() {
		self.position = generateRandomVector(xRadius: regularXRadius, yRadius: regularYRadius, zRadius: regularZRadius)
	}
	
	private func generateRandomVector(xRadius: Float, yRadius: Float, zRadius: Float) -> SCNVector3 {
        let randomX = Float.random(min: -(xRadius), max: xRadius)
        let randomY = Float.random(min: -(yRadius), max: yRadius)
        let randomZ = Float.random(min: -(zRadius), max: zRadius)
        let randomVector =  SCNVector3(randomX, randomY, randomZ)
        
        return randomVector
    }
    
    func proximityCheck(cameraPos: SCNVector3, inView : Bool ) {
        // cameraPos is camera location
        let nodePosition = self.position
        let distanceToTarget = cameraPos.distance(receiver: nodePosition)
        
        if distanceToTarget < patrolDistanceNear && !labelVisible && inView{
            // add label
            labelVisible = true
        }
        
        if distanceToTarget > patrolDistanceFar && labelVisible && !inView{
            // remove label
            labelVisible = false
        }
    }
}

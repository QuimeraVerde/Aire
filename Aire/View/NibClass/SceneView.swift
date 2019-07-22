//
//  SceneView.swift
//  Aire
//
//  Created by Natalia García on 7/23/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import ARKit
import RxSwift

class SceneView: NibView, ARSCNViewDelegate {
	@IBOutlet weak var sceneView: ARSCNView!
	var selectedPollutantID: Observable<PollutantIdentifier?>!
	var loading: Observable<Bool?>!
	private let _loading = PublishSubject<Bool?>()
	private let _selectedPollutantID = PublishSubject<PollutantIdentifier?>()
	private let disposeBag = DisposeBag()
	private let aqiToCountMultiplier = 1.5
	// At least these n individual pollutants should be close to viewer
	private let nClosePollutants: Int = 20
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let camera = sceneView.session.currentFrame?.camera {
            // position of camera
            let transform = camera.transform
            let position = SCNVector3(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            // pov of scene view for camera field of view
            guard let pointOfView = sceneView.pointOfView else { return }
            
            self.makeUpdateCameraPos(towards: position, pov: pointOfView)
        }
    }
    
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.sharedInit()
    
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.sharedInit()
	}
	
	override func prepareForInterfaceBuilder() {
		sharedInit()
	}
	
	private func sharedInit() {
        // Set the view's delegate
        sceneView.delegate = self
        
		self.selectedPollutantID = self._selectedPollutantID
		self.loading = self._loading
		let scene = SCNScene()
		self.sceneView.scene = scene
		self.sceneView.autoenablesDefaultLighting = false
		self.setupARConfiguration()
		self.addTapGesture()
	}
    
	// creates multiple nodes
	func createPollutants(pollutants: Dictionary<PollutantIdentifier,Pollutant>){
		// redraw
		cleanseLabels()
		removePollutants()
		self._selectedPollutantID.onNext(nil)
		
		// iterate through dictionary of pollutants
		for (key, value) in pollutants {
			// make sure there is data in pollutant
			let pollutantCount = Int(ceil(value.aqi) * self.aqiToCountMultiplier)
			if (pollutantCount > 0){
				
				// iterate through count of pollutants to add them to sceneview
				for i in 1...pollutantCount {
					self.addPollutant(pollutantModelID: key, pollutantCount:i)
				}
			}
		}
		self._loading.onNext(false)
	}
	
	private func setupARConfiguration() {
		let configuration = ARWorldTrackingConfiguration()
		configuration.isLightEstimationEnabled = true
		sceneView.session.run(configuration)
	}
	
	private func addTapGesture() {
		//Create TapGesture Recognizer
		let singleTap = UITapGestureRecognizer()
		singleTap.numberOfTapsRequired = 1
		
		//Create TapGesture Recognizer
		let doubleTap = UITapGestureRecognizer()
		doubleTap.numberOfTapsRequired = 2
		
		//Add recognizer to sceneview
		sceneView.addGestureRecognizer(singleTap)
		sceneView.addGestureRecognizer(doubleTap)
		singleTap.require(toFail: doubleTap)
		
		singleTap.rx.event.bind(onNext: { recognizer in
			self.handleSingleTap(rec: recognizer)
		}).disposed(by: disposeBag)
		
		doubleTap.rx.event.bind(onNext: { recognizer in
			self.handleDoubleTap(rec: recognizer)
		}).disposed(by: disposeBag)
	}
	
	//Method called when single tap
	private func handleSingleTap(rec: UITapGestureRecognizer){
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
	private func handleDoubleTap(rec: UITapGestureRecognizer){
		if rec.state == .ended {
			let location: CGPoint = rec.location(in: sceneView)
			let hits = self.sceneView.hitTest(location, options: nil)
			if !hits.isEmpty{
				let tappedNode = hits.first?.node
				// show label the same as a single tap
				self.handleTapSingleNode(node:tappedNode!)
				
				// show card as shortcut
				self._selectedPollutantID.onNext(self.getNodePollutantID(node: tappedNode!))
			}
		}
	}
	
	private func showLabel(node: SCNNode){
		let pollutantLabel = PollutantLabel()
		
		// if key is found
		if let pollutantID = PollutantIdentifier(rawValue: node.name!) {
			if let pollutantConfig = PollutantView.config[pollutantID] {
				// remove other labels
				cleanseLabels()
				
				// create label model
				pollutantLabel.loadModel(text: pollutantConfig.title,
										 fontSize: CGFloat(pollutantConfig.fontSize),
										 id: pollutantConfig.id)
				sceneView.scene.rootNode.addChildNode(pollutantLabel)
				
				// identifier for cleaning labels
				pollutantLabel.name = "label"
				
				// position label on top of model
				pollutantLabel.positionLabel(node: node,
											 yOffset: pollutantConfig.yOffset)
			}
		}
	}
	
	private func handleTapSingleNode(node: SCNNode){
		// animate tap
		SCNNodeAnimation.pulse(node: node)
		
		// grab name of node for identification purposes
		if let nodeName = node.name {
			if nodeName == "label" {
				// show info card for pollutant, name of pollutant in geometry
				let pollutantId = PollutantIdentifier(rawValue: (node.geometry?.name)!)
				self._selectedPollutantID.onNext(pollutantId!)
			}
			else {
				self._selectedPollutantID.onNext(nil)
				
				// show label for pollutant
				showLabel(node: node)
			}
		}
	}
    
    private func handleCloseProximity(nodePollutant: PollutantModel){
        let node : SCNNode = nodePollutant.childNodes.first!
        
        // animate tap
        SCNNodeAnimation.pulse(node: node)
        // grab name of node for identification purposes
        if let nodeName = node.name {
            if nodeName == "label" {
                // show info card for pollutant, name of pollutant in geometry
                let pollutantId = PollutantIdentifier(rawValue: (node.geometry?.name)!)
                self._selectedPollutantID.onNext(pollutantId!)
            }
            else {
                self._selectedPollutantID.onNext(nil)
                
                // show label for pollutant
                showLabel(node: node)
            }
        }
    }
	
	// remove all nodes from scene view
	func removePollutants(){
		self._loading.onNext(true)
		
		sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
			node.removeFromParentNode()
		}
	}

	// add individual node pollutant
	private func addPollutant(pollutantModelID: PollutantIdentifier,
							  pollutantCount: Int) {
		
		let pollutantModel = PollutantModel()
		pollutantModel.loadModel(modelID:pollutantModelID)
		sceneView.scene.rootNode.addChildNode(pollutantModel)
		
		// fade in
		SCNNodeAnimation.fadeIn(pollutantModel)
		
		// animate pollutant
		SCNNodeAnimation.rotateRandomly(pollutantModel)
		
		// position pollutant
		if (pollutantCount < nClosePollutants) {
			pollutantModel.setPositionNear()
		}
		else {
			pollutantModel.setPositionAnywhere()
		}
	}
	
	private func getNodePollutantID(node: SCNNode) -> PollutantIdentifier {
		// grab name of node for identification purposes
		var pollutantID = PollutantIdentifier()
		if let nodeName = node.name {
			if nodeName == "label" {
				pollutantID = PollutantIdentifier(rawValue: (node.geometry?.name)!)!
			}
			else {
				pollutantID = PollutantIdentifier(rawValue: nodeName)!
			}
		}
		return pollutantID
	}
	
	// remove all labels from scene view
	private func cleanseLabels(){
		sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
			if node.name == "label" {
				node.removeFromParentNode()
			}
		}
	}
    
    // camera position for adding labels
    func makeUpdateCameraPos(towards: SCNVector3, pov: SCNNode) {
        
        // for any node in scene view
        sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
            if let pollutant = node as? PollutantModel {
                let node : SCNNode = pollutant.childNodes.first!
                let currentLabelVisibleState = pollutant.labelVisible
                
                // is node in view
                let inFustrum = sceneView.isNode(node, insideFrustumOf: pov)
                // is node close enough
                pollutant.proximityCheck(cameraPos: towards, inView: inFustrum)
                
                // handles state of node
                let newLabelVisibleState = pollutant.labelVisible
                
                if (newLabelVisibleState != currentLabelVisibleState) && newLabelVisibleState {
                    // update node
                    handleCloseProximity(nodePollutant: pollutant)
                }
            }
        })
    }
}

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

class SceneView: NibView {
	@IBOutlet weak var sceneView: AireSceneView!
	var selectedPollutantID: Observable<PollutantIdentifier?>!
	var loading: Observable<Bool?>!
	private let _loading = PublishSubject<Bool?>()
	private let _selectedPollutantID = PublishSubject<PollutantIdentifier?>()
	private let disposeBag = DisposeBag()
	private let aqiToCountMultiplier = 1.5
	// At least these n individual pollutants should be close to viewer
	private let nClosePollutants: Int = 20
	
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
		self.selectedPollutantID = self._selectedPollutantID
		self.loading = self._loading
		self.sceneView.scene = SCNScene()
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
		pollutantModel.delegate = self.sceneView
		pollutantModel.sceneView = self.sceneView
		pollutantModel.subscribe(pointOfView: self.sceneView.observable)
		
		pollutantModel.loadModel(modelID:pollutantModelID)
		sceneView.scene.rootNode.addChildNode(pollutantModel)
		
		// fade in
		SCNNodeAnimation.fadeIn(pollutantModel)
		
		// animate pollutant
		SCNNodeAnimation.rotateRandomly(pollutantModel)
		
		// position pollutant
//		if (pollutantCount < nClosePollutants) {
//			pollutantModel.setPositionNear()
//		}
//		else {
//			pollutantModel.setPositionAnywhere()
//		}
		if let pov = self.sceneView.pointOfView {
			pollutantModel.setPositionInPointOfView(pointOfView: pov)
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
}

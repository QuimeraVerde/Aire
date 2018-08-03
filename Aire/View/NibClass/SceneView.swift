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
	@IBOutlet weak var sceneView: ARSCNView!
	var selectedPollutantID: Observable<PollutantIdentifier?>!
	var loading: Observable<Bool?>!
	private let _loading = PublishSubject<Bool?>()
	private let _selectedPollutantID = PublishSubject<PollutantIdentifier?>()
	private let disposeBag = DisposeBag()
	
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
			if (value.count > 0){
				
				// iterate through count of pollutants to add them to sceneview
				for i in 1...value.count {
					addPollutant(pollutantModelID: key, index:i)
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
		//let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(rec:)))
		let singleTap = UITapGestureRecognizer()
		singleTap.numberOfTapsRequired = 1
		
		//Create TapGesture Recognizer
		//let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(rec:)))
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
	
	private func handleTapSingleNode(node: SCNNode){
		// animate tap
		animateTap(node:node)
		
		// grab name of node for identification purposes
		let nodeName: String = node.name ?? "none"
		
		if (nodeName == "label") {
			// show info card for pollutant, name of pollutant in geometry
			
			let pollutantId = PollutantIdentifier(rawValue: node.geometry?.name ?? "none")
			self._selectedPollutantID.onNext(pollutantId!)
		}
			
		else {
			self._selectedPollutantID.onNext(nil)
			
			// show label for pollutant
			showLabel(node: node)
		}
	}
	
	private func animateTap(node: SCNNode){
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
	private func easeOutElastic(_ t: Float) -> Float {
		let p: Float = 0.3
		let newValue: Float = ( t - p )
		let sinValue: Float = ( newValue / 4.0) * (2.0 * Float.pi) / p
		let result = pow(2.0, -10.0 * t) * sin(sinValue) + 1.0
		return result
	}
	
	// remove all nodes from scene view
	private func removePollutants(){
		self._loading.onNext(true)
		
		sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
			node.removeFromParentNode()
		}
	}

	// add individual node pollutant
	private func addPollutant(pollutantModelID: PollutantIdentifier, index: Int) {
		let pollutantModel = PollutantModel()
		pollutantModel.loadModel(modelID:pollutantModelID)
		sceneView.scene.rootNode.addChildNode(pollutantModel)
		
		// fade in
		pollutantModel.fadeInAction()
		
		// animate pollutant
		pollutantModel.animate(objectCount:index)
		
		// randomize position
		pollutantModel.randomPosition(objectCount:index)
	}
	
	private func getNodePollutantID(node: SCNNode) -> PollutantIdentifier {
		// grab name of node for identification purposes
		var nodeName: String = node.name ?? "none"
		
		// check if label
		if (nodeName == "label") {
			// name of pollutant in geometry
			nodeName = node.geometry?.name ?? "none"
		}
		
		return PollutantIdentifier(rawValue: nodeName)!
	}
	
	private func showLabel(node: SCNNode){
		let pollutantLabel = PollutantLabel()

		// if key is found
		if let pollutantID = PollutantIdentifier(rawValue: node.name!) {
			if let pollutantConfig = PollutantUtility.config.model[pollutantID] {
				// remove other labels
				cleanseLabels()

				// create label model
				pollutantLabel.loadModel(text: pollutantConfig.text,
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
	
	// remove all labels from scene view
	private func cleanseLabels(){
		sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
			if node.name == "label" {
				node.removeFromParentNode()
			}
		}
	}
}

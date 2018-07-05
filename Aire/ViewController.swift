//
//  ViewController.swift
//  Aire
//
//  Created by Pau Escalante on 6/21/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet var pollutantLabel: UILabel!
    @IBOutlet var pollutantCard: UIView!
    @IBOutlet var SegmentedMenu: UISegmentedControl!
    
    @IBAction func closeCard(_ sender: UIButton) {
        // hide card
        hideCard()
    }
    
    let pollutantsConfig : Dictionary<String,ModelConfiguration> = [
        "pm10" : ModelConfiguration(title: "pm10",
                                    fontSize: 3.0,
                                    text: "PM10",
                                    fullName: "Partículas PM10",
                                    yOffset: 0.07),
        "pm25" : ModelConfiguration(title: "pm25",
                                    fontSize: 2.5,
                                    text: "PM2.5",
                                    fullName: "Partículas PM2.5",
                                    yOffset: 0.05),
        "co" : ModelConfiguration(title: "co",
                                    fontSize: 4.0,
                                    text: "CO",
                                    fullName: "Monóxido de Carbono",
                                    yOffset: 0.06)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupConfiguration()
        // Right now static, later receive from API
        let pollutants : Dictionary<String,Pollutant> = [
            "pm10" : Pollutant(title: "pm10", value: Int(88*1.5)),
            "co" : Pollutant(title: "co", value: Int(24*1.5)),
            "pm25" : Pollutant(title: "pm25", value: Int(168*1.5))
        ]
        
        createPollutants(pollutants: pollutants)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScene() {
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = false
    }
    
    func setupConfiguration() {
        // UI for card
        pollutantCard.layer.cornerRadius = 10
        pollutantCard.layer.masksToBounds = true
        SegmentedMenu.selectedSegmentIndex = 0
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
        
        addTapGesture()
    }
    
    // load data on pollutant card and show
    func showCard(){
        pollutantCard.isHidden = false
    }
    
    // reset data on pollutant card and hide
    func hideCard(){
        pollutantCard.isHidden = true
        SegmentedMenu.selectedSegmentIndex = 0
    }
    
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
    
    func showPollutantInfo(pollutantName: String){
        if (pollutantsConfig[pollutantName] != nil) {
            let pollutantConfig: ModelConfiguration = pollutantsConfig[pollutantName]!
            pollutantLabel.text = pollutantConfig.fullName
            
            // unhide card
            showCard()
        }
    }
    
    func showLabel(pollutantKey: String, node: SCNNode){
        let pollutantLabel = PollutantLabel()
        var pollutantText: String = ""
        var pollutantTitle: String = ""
        var pollutantYOffset: Float = 0.0
        var pollutantFont: Float = 0.0
 
        // if key is found
        if (pollutantsConfig[pollutantKey] != nil) {
            // remove other labels
            cleanseLabels()
            
            let pollutantConfig: ModelConfiguration = pollutantsConfig[pollutantKey]!
            
            pollutantText = pollutantConfig.text
            pollutantYOffset = pollutantConfig.yOffset
            pollutantFont = pollutantConfig.fontSize
            pollutantTitle = pollutantConfig.title
            
            // create label model
            pollutantLabel.loadModel(text:pollutantText, fontSize: CGFloat(pollutantFont), title: pollutantTitle)
            sceneView.scene.rootNode.addChildNode(pollutantLabel)
            
            // identifier for cleaning labels
            pollutantLabel.name = "label"
            
            // position label on top of model
            pollutantLabel.positionLabel(node:node, yOffset: pollutantYOffset)
        }
    }
    
    // remove all labels from scene view
    func cleanseLabels(){
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            if node.name == "label" {
                node.removeFromParentNode()
            }
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
    
    // remove all nodes from scene view
    func cleanseSceneView(){
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
        }
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
}


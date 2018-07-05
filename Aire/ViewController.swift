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
    
    let pollutantsConfig : Dictionary<String,ModelConfiguration> = [
        "pm10" : ModelConfiguration(title: "pm10", fontSize: 3.0, text: "PM10", yOffset: 0.07),
        "pm25" : ModelConfiguration(title: "pm25", fontSize: 2.5, text: "PM2.5", yOffset: 0.05),
        "co" : ModelConfiguration(title: "co", fontSize: 4.0, text: "CO", yOffset: 0.06)
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
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
        
        addTapGesture()
    }
    
    func addTapGesture() {
        //Create TapGesture Recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(rec:)))
        
        //Add recognizer to sceneview
        sceneView.addGestureRecognizer(tap)
    }
    
    //Method called when tap
    @objc func handleTap(rec: UITapGestureRecognizer){
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let tappedNode = hits.first?.node
                handleTap(node:tappedNode!)
            }
        }
    }
    
    func handleTap(node: SCNNode){
        // animate tap
        animateTap(node:node)
        
        // show information
        showLabel(node:node)
    }
    
    func showLabel(node: SCNNode){
        let pollutantLabel = PollutantLabel()
        var pollutantText: String = ""
        var pollutantYOffset: Float = 0.0
        var pollutantFont: Float = 0.0
        var pollutantKey: String = ""
        
        let nameNode = node.name
        
        switch(nameNode){
        case "pm10":
            pollutantKey = "pm10"
        case "pm25":
            pollutantKey = "pm25"
        case "co":
            pollutantKey = "co"
        case "label":
            print("show info")
        default: break
        }
        
        // if key is found
        if (pollutantsConfig[pollutantKey] != nil) {
            // remove other labels
            cleanseLabels()
            
            let pollutantConfig: ModelConfiguration = pollutantsConfig[pollutantKey]!
            
            pollutantText = pollutantConfig.text
            pollutantYOffset = pollutantConfig.yOffset
            pollutantFont = pollutantConfig.fontSize
            
            // create label model
            pollutantLabel.loadModel(text:pollutantText, fontSize: CGFloat(pollutantFont))
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
                print("label *")
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


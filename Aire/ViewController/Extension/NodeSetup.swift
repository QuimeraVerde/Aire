
//
//  NodeSetup
//  Aire
//
//  Created by Pau Escalante on 7/7/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension ViewController {
    
    // creates multiple nodes
    func createPollutants(pollutants: Dictionary<PollutantIdentifier,Pollutant>, dominant: PollutantIdentifier){
        // redraw
        cleanseLabels()
        removePollutants()
		//hideCard()
		self.pollutantCardView.hide()

        // Store pollutants in global variable
        pollutantsInfo = pollutants
        dominantPollutant = dominant
        
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
        
        loadingIcon.stopAnimating()
    }
    
    // remove all nodes from scene view
    func removePollutants(){
        loadingIcon.startAnimating()
        
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    
    func addTimestamp(timestamp: Date){
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm a"
        
        lastUpdated.text = "Última actualización: " + dateFormatterGet.string(from: timestamp)
    }
    
    // add individual node pollutant
    func addPollutant(pollutantModelID: PollutantIdentifier, index: Int) {
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
	
	func getNodePollutant(node: SCNNode) -> Pollutant{
		// grab name of node for identification purposes
		var nodeName: String = node.name ?? "none"
		
		// check if label
		/*if (nodeName == "label") {
			throws exampleError("Pollutant not found")
		}*/
		
		if (nodeName == "label") {
			// name of pollutant in geometry
			nodeName = node.geometry?.name ?? "none"
		}
		
		return self.pollutantsInfo[PollutantIdentifier(rawValue: nodeName)!]!
	}
}

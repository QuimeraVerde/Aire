//
//  PollutantCache.swift
//  Aire
//
//  Created by Patricio Beltran on 6/2/19.
//  Copyright © 2019 QuimeraVerde. All rights reserved.
//

import Foundation
import ARKit

class PollutantCache {
    static let shared = PollutantCache()
    
    private var _sceneCache: Dictionary<PollutantIdentifier, SCNNode> = Dictionary<PollutantIdentifier, SCNNode>()
    
    public func getSceneNode(id: PollutantIdentifier) -> SCNNode? {
        return _sceneCache[id]
    }
    
    public func setSceneNode(id: PollutantIdentifier) -> SCNNode {
        let virtualObjectScene = SCNScene(named: id.rawValue + ".scn")!
        
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        wrapperNode.name = id.rawValue
        
        _sceneCache[id] = wrapperNode
        
        return wrapperNode
    }
}

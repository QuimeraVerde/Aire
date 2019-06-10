//
//  SceneSession.swift
//  
//
//  Created by Natalia García on 6/9/19.
//

import ARKit

class SceneSession: ARSession, ARSessionDelegate {
	func session(_ session: ARSession, didUpdate frame: ARFrame) {
		print("Frame changed.")
		print(session)
		print(frame)
	}
}

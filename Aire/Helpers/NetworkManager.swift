//
//  NetworkManager.swift
//  Aire
//
//  Created by Natalia García on 8/1/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
// 	https://blog.pusher.com/handling-internet-connection-reachability-swift/

import Foundation
import Reachability

class NetworkManager: NSObject {
	
	var reachability: Reachability!
	
	// Create a singleton instance
	static let shared: NetworkManager = { return NetworkManager() }()
	
	override init() {
		super.init()
		
		// Initialise reachability
		reachability = Reachability()!
		
		// Register an observer for the network status
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(networkStatusChanged(_:)),
			name: .reachabilityChanged,
			object: reachability
		)
		
		do {
			// Start the network status notifier
			try reachability.startNotifier()
		} catch {
			print("Unable to start notifier")
		}
	}
	
	@objc func networkStatusChanged(_ notification: Notification) {
		// Do something globally here!
	}
	
	static func stopNotifier() -> Void {
		do {
			// Stop the network status notifier
			try (NetworkManager.shared.reachability).startNotifier()
		} catch {
			print("Error stopping notifier")
		}
	}
	
	// Network is reachable
	static func isReachable(completed: @escaping (NetworkManager) -> Void) {
		if (NetworkManager.shared.reachability).connection != .none {
			completed(NetworkManager.shared)
		}
	}
	
	// Network is unreachable
	static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
		if (NetworkManager.shared.reachability).connection == .none {
			completed(NetworkManager.shared)
		}
	}
}

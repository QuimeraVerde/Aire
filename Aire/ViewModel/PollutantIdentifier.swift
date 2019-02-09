//
//  PollutantName.swift
//  Aire
//
//  Created by Natalia García on 7/11/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation

enum PollutantIdentifier: String {
	case co
	case no2
	case o3
	case pm10
	case pm25
	case so2
	
	init() {
		self = .pm10
	}
	
	static let allCases = [co, no2, o3, pm10, pm25, so2]
}

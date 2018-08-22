//
//  Pollutant.swift
//  Aire
//
//  Created by Natalia García on 7/3/18.
//  Copyright © 2018 Natalia García. All rights reserved.
//

import Foundation

struct Pollutant {
	var aqi: Double = 0.0
	var id: PollutantIdentifier = PollutantIdentifier()
	init(id: PollutantIdentifier) {
        self.id = id
	}
	init(rawValue : [String: Any]) {
		self.aqi = (rawValue["v"] as? Double)!
	}
}

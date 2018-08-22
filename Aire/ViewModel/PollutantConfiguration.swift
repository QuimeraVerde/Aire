//
//  ModelConfiguration.swift
//  Aire
//
//  Created by Pau Escalante on 7/4/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

struct PollutantConfiguration {
	var fontSize : Float = 0.0
	var title : String = ""
	var extendedTitle: String = ""
	var yOffset: Float = 0.0
	var ranges = [Int]()
	var id: PollutantIdentifier!
	
	init(id : PollutantIdentifier) {
		self.id = id
	}

	init(id: PollutantIdentifier, fontSize: Float, title: String, extendedTitle: String, yOffset: Float, ranges: [Int]) {
		self.id = id
		self.fontSize = fontSize
		self.title = title
		self.yOffset = yOffset
		self.extendedTitle = extendedTitle
		self.ranges = ranges
	}

	func getLevel(aqiValue: Double) -> Int{
		// aqiValue is not negative
		for i in 0..<ranges.count {
			if aqiValue < Double(ranges[i]) {
				return i-1
			}
		}
		// reached end of array and did not find a situable range (out of range)
		return ranges.count-1
	}
}

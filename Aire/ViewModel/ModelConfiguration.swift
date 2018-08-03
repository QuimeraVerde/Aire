//
//  ModelConfiguration.swift
//  Aire
//
//  Created by Pau Escalante on 7/4/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

struct ModelConfiguration {
	var fontSize : Float = 0.0
	var text : String = ""
	var fullName: String = ""
	var yOffset: Float = 0.0
	var ranges = [Int]()
	var id: PollutantIdentifier!
	
	init(id : PollutantIdentifier) {
		self.id = id
	}

	init(id: PollutantIdentifier, fontSize: Float, text: String, fullName: String, yOffset: Float, ranges: [Int]) {
		self.id = id
		self.fontSize = fontSize
		self.text = text
		self.yOffset = yOffset
		self.fullName = fullName
		self.ranges = ranges
	}
	// gets range of color level for visualization of aqi
	func getRange(aqiValue: Int) -> String{
		// aqiValue is not negative
		for i in 0..<ranges.count {
			if aqiValue < ranges[i] {
				return String(i)
			}
		}
		// reached end of array and did not find a situable range (out of range)
		return String(ranges.count)
	}
}

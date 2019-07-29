 //
//  AirQualityScale.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UIKit

struct AirQualityScale {
	enum LevelTitle: String {
		case Good = "Good"
		case Moderate = "Moderate"
		case UnhealthyForSensitiveGroups = "Unhealthy for Sensitive Groups"
		case Unhealthy = "Unhealthy"
		case VeryUnhealthy = "Very Unhealthy"
		case Hazardous = "Hazardous"
	}
	
	struct Level {
		let title: LevelTitle
		let color: UIColor
	}
	
	private static let level: [Level] = [
		Level(title: LevelTitle.Good,
			  color: UIUtility.color.green),
		
		Level(title: LevelTitle.Moderate,
			  color: UIUtility.color.yellow),
		
		Level(title: LevelTitle.UnhealthyForSensitiveGroups,
			  color: UIUtility.color.orange),
		
		Level(title: LevelTitle.Unhealthy,
			  color: UIUtility.color.red),
		
		Level(title: LevelTitle.VeryUnhealthy,
			  color: UIUtility.color.purple),
		
		Level(title: LevelTitle.Hazardous,
			  color: UIUtility.color.crimson)
	]
	
	static func getLevelForIndex(index: Double) -> Level {
		switch index {
		case 0...50:
			return self.level[0]
		case 51...100:
			return self.level[1]
		case 101...150:
			return self.level[2]
		case 151...200:
			return self.level[3]
		case 201...300:
			return self.level[4]
		default:
			return self.level[5]
		}
	}
}


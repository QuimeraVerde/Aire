//
//  AirQualityUtility.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UIKit

struct AirQualityUtility {
	static let scale = Scale()
	
	enum AirPollutionLevel: String {
		case Good = "Bueno"
		case Moderate = "Moderado"
		case UnhealthyForSensitiveGroups = "Dañino a la salud para grupos sensibles"
		case Unhealthy = "Dañino a la salud"
		case VeryUnhealthy = "Muy dañino a la salud"
		case Hazardous = "Peligroso"
	}
	
	struct Scale {
		struct Level {
			let range: CountableClosedRange<Int>
			let airPollutionLevel: AirPollutionLevel
			let color: UIColor
		}
		
		private static let level: [Level] = [
			Level(range: 0...50,
				  airPollutionLevel: AirPollutionLevel.Good,
				  color: UIUtility.color.green),
			
			Level(range: 51...100,
				  airPollutionLevel: AirPollutionLevel.Moderate,
				  color: UIUtility.color.yellow),
			
			Level(range: 101...150,
				  airPollutionLevel: AirPollutionLevel.UnhealthyForSensitiveGroups,
				  color: UIUtility.color.orange),
			
			Level(range: 151...200,
				  airPollutionLevel: AirPollutionLevel.Unhealthy,
				  color: UIUtility.color.red),
			
			Level(range: 201...300,
				  airPollutionLevel: AirPollutionLevel.VeryUnhealthy,
				  color: UIUtility.color.purple),
			
			Level(range: 300...500,
				  airPollutionLevel: AirPollutionLevel.Hazardous,
				  color: UIUtility.color.crimson)
		]
		
		subscript(index: Double) -> Level {
			get {
				switch index {
				case 0...50:
					return AirQualityUtility.Scale.level[0]
				case 51...100:
					return AirQualityUtility.Scale.level[1]
				case 101...150:
					return AirQualityUtility.Scale.level[2]
				case 151...200:
					return AirQualityUtility.Scale.level[3]
				case 201...300:
					return AirQualityUtility.Scale.level[4]
				default:
					return AirQualityUtility.Scale.level[5]
				}
			}
		}
	}
}

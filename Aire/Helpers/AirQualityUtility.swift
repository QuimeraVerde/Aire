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
	enum AirPollutionLevel: String {
		case Good = "Bueno"
		case Moderate = "Moderado"
		case UnhealthyForSensitiveGroups = "Dañino a la salud para grupos sensibles"
		case Unhealthy = "Dañino a la salud"
		case VeryUnhealthy = "Muy dañino a la salud"
		case Hazardous = "Peligroso"
	}
	
	struct Level {
		let title: AirPollutionLevel
		let color: UIColor
	}
	
	private static let level: [Level] = [
		Level(title: AirPollutionLevel.Good,
			  color: UIUtility.color.green),
		
		Level(title: AirPollutionLevel.Moderate,
			  color: UIUtility.color.yellow),
		
		Level(title: AirPollutionLevel.UnhealthyForSensitiveGroups,
			  color: UIUtility.color.orange),
		
		Level(title: AirPollutionLevel.Unhealthy,
			  color: UIUtility.color.red),
		
		Level(title: AirPollutionLevel.VeryUnhealthy,
			  color: UIUtility.color.purple),
		
		Level(title: AirPollutionLevel.Hazardous,
			  color: UIUtility.color.crimson)
	]
	
	static func getPollutantAQILevel(pollutant: Pollutant) -> Level {
		let pollutantConfig = PollutantUtility.config.model[pollutant.id]!
		let levelIndex = pollutantConfig.getLevel(aqiValue: pollutant.aqi)
		
		return self.level[levelIndex]
	}
	
	static let generalAQILevel = GeneralAQILevel()
	
	struct GeneralAQILevel {
		subscript(index: Double) -> Level {
			get {
				switch index {
				case 0...50:
					return AirQualityUtility.level[0]
				case 51...100:
					return AirQualityUtility.level[1]
				case 101...150:
					return AirQualityUtility.level[2]
				case 151...200:
					return AirQualityUtility.level[3]
				case 201...300:
					return AirQualityUtility.level[4]
				default:
					return AirQualityUtility.level[5]
				}
			}
		}
	}
}


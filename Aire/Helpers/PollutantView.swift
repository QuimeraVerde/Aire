//
//  PollutantView.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation

struct PollutantView {
	struct PollutantConfiguration {
		var id: PollutantIdentifier
		var title : String = ""
		var extendedTitle: String = ""
		var fontSize : Float = 0.0
		var yOffset: Float = 0.0
	}
	
	static let config: Dictionary<PollutantIdentifier,PollutantConfiguration> = [
		.pm10 : PollutantConfiguration(id: .pm10,
									   title: "PM10",
									   extendedTitle: "Particulate Matter 10",
									   fontSize: 3.0,
									   yOffset: 0.07),
		.pm25 : PollutantConfiguration(id: .pm25,
									   title: "PM2.5",
									   extendedTitle: "Particulate Matter 2.5",
									   fontSize: 2.5,
									   yOffset: 0.05),
		.co : PollutantConfiguration(id: .co,
									 title: "CO",
									 extendedTitle: "Carbon Monoxide",
									 fontSize: 4.0,
									 yOffset: 0.06),
		.so2 : PollutantConfiguration(id: .so2,
									  title: "SO2",
									  extendedTitle: "Sulfur Dioxide",
									  fontSize: 4.0,
									  yOffset: 0.06),
		.no2 : PollutantConfiguration(id: .no2,
									  title: "NO2",
									  extendedTitle: "‎Nitrogen Dioxide",
									  fontSize: 4.0,
									  yOffset: 0.06),
		.o3 : PollutantConfiguration(id: .o3,
									 title: "O3",
									 extendedTitle: "Ozone",
									 fontSize: 4.0,
									 yOffset: 0.06)
	]
}

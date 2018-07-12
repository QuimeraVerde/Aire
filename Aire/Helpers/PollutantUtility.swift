//
//  PollutantUtility.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation

struct PollutantUtility {
	static let config = Configuration()
	struct Configuration {
		var model: Dictionary<PollutantIdentifier,ModelConfiguration> = Dictionary<PollutantIdentifier,ModelConfiguration>()
		init() {
			self.model = [
				PollutantIdentifier.pm10 : ModelConfiguration(id: PollutantIdentifier.pm10,
															  title: "pm10",
															  fontSize: 3.0,
															  text: "PM10",
															  fullName: "Partículas PM10",
															  yOffset: 0.07,
															  ranges: [0,51,101,151,201,301]),
				PollutantIdentifier.pm25 : ModelConfiguration(id: PollutantIdentifier.pm25,
															  title: "pm25",
															  fontSize: 2.5,
															  text: "PM2.5",
															  fullName: "Partículas PM2.5",
															  yOffset: 0.05,
															  ranges: [0,51,101,151,201,301]),
				PollutantIdentifier.co : ModelConfiguration(id: PollutantIdentifier.co,
															title: "co",
															fontSize: 4.0,
															text: "CO",
															fullName: "Monóxido de Carbono",
															yOffset: 0.06,
															ranges: [0,51,101,151,201,301]),
				PollutantIdentifier.so2 : ModelConfiguration(id: PollutantIdentifier.so2,
															 title: "so2",
															 fontSize: 4.0,
															 text: "SO2",
															 fullName: "Dióxido de Azufre",
															 yOffset: 0.06,
															 ranges: [0,51,101,151,201,301]),
				PollutantIdentifier.no2 : ModelConfiguration(id: PollutantIdentifier.no2,
															 title: "no2",
															 fontSize: 4.0,
															 text: "NO2",
															 fullName: "‎Dióxido de Nitrógeno",
															 yOffset: 0.06,
															 ranges: [0,51,101,151,201,301]),
				PollutantIdentifier.o3 : ModelConfiguration(id: PollutantIdentifier.o3,
															title: "o3",
															fontSize: 4.0,
															text: "O3",
															fullName: "Moléculas de Ozono",
															yOffset: 0.06,
															ranges: [0,51,101,151,201,301]),
			]
		}
	}
}

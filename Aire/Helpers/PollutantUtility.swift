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
				.pm10 : ModelConfiguration(id: .pm10,
										   title: "pm10",
										   fontSize: 3.0,
										   text: "PM10",
										   fullName: "Partículas PM10",
										   yOffset: 0.07,
										   ranges: [0,51,101,151,201,301]),
				.pm25 : ModelConfiguration(id: .pm25,
										   title: "pm25",
										   fontSize: 2.5,
										   text: "PM2.5",
										   fullName: "Partículas PM2.5",
										   yOffset: 0.05,
										   ranges: [0,51,101,151,201,301]),
				.co : ModelConfiguration(id: .co,
										 title: "co",
										 fontSize: 4.0,
										 text: "CO",
										 fullName: "Monóxido de Carbono",
										 yOffset: 0.06,
										 ranges: [0,51,101,151,201,301]),
				.so2 : ModelConfiguration(id: .so2,
										  title: "so2",
										  fontSize: 4.0,
										  text: "SO2",
										  fullName: "Dióxido de Azufre",
										  yOffset: 0.06,
										  ranges: [0,51,101,151,201,301]),
				.no2 : ModelConfiguration(id: .no2,
										  title: "no2",
										  fontSize: 4.0,
										  text: "NO2",
										  fullName: "‎Dióxido de Nitrógeno",
										  yOffset: 0.06,
										  ranges: [0,51,101,151,201,301]),
				.o3 : ModelConfiguration(id: .o3,
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

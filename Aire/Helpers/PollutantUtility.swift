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
		var model: Dictionary<PollutantIdentifier,PollutantConfiguration> = Dictionary<PollutantIdentifier,PollutantConfiguration>()
		init() {
			self.model = [
				.pm10 : PollutantConfiguration(id: .pm10,
										   fontSize: 3.0,
										   title: "PM10",
										   extendedTitle: "Partículas PM10",
										   yOffset: 0.07,
										   ranges: [0,51,101,151,201,301]),
				.pm25 : PollutantConfiguration(id: .pm25,
										   fontSize: 2.5,
										   title: "PM2.5",
										   extendedTitle: "Partículas PM2.5",
										   yOffset: 0.05,
										   ranges: [0,51,101,151,201,301]),
				.co : PollutantConfiguration(id: .co,
										 fontSize: 4.0,
										 title: "CO",
										 extendedTitle: "Monóxido de Carbono",
										 yOffset: 0.06,
										 ranges: [0,51,101,151,201,301]),
				.so2 : PollutantConfiguration(id: .so2,
										  fontSize: 4.0,
										  title: "SO2",
										  extendedTitle: "Dióxido de Azufre",
										  yOffset: 0.06,
										  ranges: [0,51,101,151,201,301]),
				.no2 : PollutantConfiguration(id: .no2,
										  fontSize: 4.0,
										  title: "NO2",
										  extendedTitle: "‎Dióxido de Nitrógeno",
										  yOffset: 0.06,
										  ranges: [0,51,101,151,201,301]),
				.o3 : PollutantConfiguration(id: .o3,
										 fontSize: 4.0,
										 title: "O3",
										 extendedTitle: "Moléculas de Ozono",
										 yOffset: 0.06,
										 ranges: [0,51,101,151,201,301]),
			]
		}
	}
}

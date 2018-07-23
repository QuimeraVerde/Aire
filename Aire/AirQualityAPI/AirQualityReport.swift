//
//  AirQualityReport.swift
//  Aire
//
//  Created by Natalia García on 7/3/18.
//  Copyright © 2018 Natalia García. All rights reserved.
//

import RxSwift
import class Foundation.NSDictionary

class AirQualityReport {
	var aqi : Double = 0
	var location : String = ""
	var timestamp : Date = Date()
	var dominantPollutantID : PollutantIdentifier = .pm10
	var pollutants: Dictionary<PollutantIdentifier, Pollutant> = Dictionary<PollutantIdentifier, Pollutant>()
	static private var pollutantsInit : Dictionary<PollutantIdentifier,Pollutant> = [
		.pm10 : Pollutant(id: .pm10,
						  title: "PM10",
						  extendedTitle: "Partículas PM10"),
		.pm25 : Pollutant(id: .pm25,
						  title: "PM2.5",
						  extendedTitle: "Partículas PM2.5"),
		.so2  : Pollutant(id: .so2,
						  title: "SO2",
						  extendedTitle: "Monóxido de Carbono"),
		.co   : Pollutant(id: .co,
						  title: "CO",
						  extendedTitle: "Dióxido de Azufre"),
		.o3   : Pollutant(id: .o3,
						  title: "O3",
						  extendedTitle: "‎Dióxido de Nitrógeno"),
		.no2  : Pollutant(id: .no2,
						  title: "NO2",
						  extendedTitle: "Moléculas de Ozono")
	]

	static func parseJSON(_ json: NSDictionary) throws -> AirQualityReport {
		guard let aqi 				= json["aqi"] 			as? Double,
			let dominantPollutantID 	= PollutantIdentifier(rawValue: (json["dominentpol"] as? String)!),
			let locationJSON 		= json["city"] 			as? [String: Any],
			let location 			= locationJSON["name"]	as? String,
			let pollutantsJSON 		= json["iaqi"] 			as? [String: [String: Double]]
			else {
				throw apiError("Error parsing air quality report")
		}
		
		var pollutants = self.pollutantsInit
		
		for string in pollutantsJSON {
			if let pollutantID = PollutantIdentifier(rawValue: string.key) {
				let pollutant = Pollutant(rawValue: string.value)
				pollutants[pollutantID]?.aqi = pollutant.aqi
				pollutants[pollutantID]?.count = pollutant.count
			}
		}
		
		return AirQualityReport(aqi: aqi, location: location, timestamp: Date(), dominantPollutantID: dominantPollutantID, pollutants: pollutants)
	}
	
	init(aqi: Double, location: String, timestamp: Date, dominantPollutantID: PollutantIdentifier, pollutants: Dictionary<PollutantIdentifier, Pollutant>) {
		self.aqi = aqi
		self.location = location
		self.timestamp = timestamp
		self.dominantPollutantID = dominantPollutantID
		self.pollutants = pollutants
	}
	
	init() {
		
	}
}

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
	var dominantPollutantID : PollutantIdentifier = PollutantIdentifier()
	var pollutants: Dictionary<PollutantIdentifier, Pollutant> = Dictionary<PollutantIdentifier, Pollutant>()
	static internal let pollutantsInit : Dictionary<PollutantIdentifier,Pollutant> = [
		.pm10 : Pollutant(id: .pm10),
		.pm25 : Pollutant(id: .pm25),
		.so2  : Pollutant(id: .so2),
		.co   : Pollutant(id: .co),
		.o3   : Pollutant(id: .o3),
		.no2  : Pollutant(id: .no2)
	]

	static func parseJSON(_ json: NSDictionary) throws -> AirQualityReport {
		// get general info from json
		guard let aqi 				= json["aqi"] 			as? Double,
			let locationJSON 		= json["city"] 			as? [String: Any],
			let location 			= locationJSON["name"]	as? String,
			let pollutantsJSON 		= json["iaqi"] 			as? [String: [String: Double]]
			else {
				throw apiError("Error parsing air quality report")
		}
		
		// create pollutants dictionary
		var pollutants = self.pollutantsInit
		
		for string in pollutantsJSON {
			if let pollutantID = PollutantIdentifier(rawValue: string.key) {
				let pollutant = Pollutant(rawValue: string.value)
				pollutants[pollutantID]?.aqi = pollutant.aqi
			}
		}
		
		// try and get dominant pollutant from json, if it's not present, assign the first pollutant that matches the aqi
		var dominantPollutantID: PollutantIdentifier
		
		if let dominantPollutant = json["dominentpol"] {
			dominantPollutantID = PollutantIdentifier(rawValue: dominantPollutant as! String)!
		}
		else {
			dominantPollutantID = (pollutants.filter { (pollutantID, pollutant) -> Bool in
				pollutant.aqi == aqi
				}.first?.key)!
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
	
	init() { }
}

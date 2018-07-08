//
//  SubscriptionsSetup.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

extension ViewController {
	func setupLocationSubscription() {
		setupCoordinateSubscription()
		setupAddressSubscription()
	}
	func setupAddressSubscription() {
		let AirQualityAPI = DefaultAirQualityAPI.sharedAPI
		Location.sharedAddress.observable.subscribe(onNext:  { [weak self] address in
			DispatchQueue.main.async {
				self?.addressLabel.text = address
			}
		}).disposed(by: disposeBag)
	}
	func setupCoordinateSubscription() {
		let AirQualityAPI = DefaultAirQualityAPI.sharedAPI
		let _ = Location.sharedCoordinate.observable.map{ coord in AirQualityAPI.report(coord) }
			.concat()
			.map { $0 }
			.bind(onNext: { (aqReport) in
				self.setAQIMeter(aqi: aqReport.aqi)
				self.addTimestamp(timestamp: aqReport.timestamp)
				self.createPollutants(pollutants: aqReport.pollutants)
			})
	}
	
	func setAQIMeter(aqi: Double) {
		let aqiScaleData = AirQualityUtility.scale[aqi]
		
		// 1. Update air quality index label
		self.aqiLabel.text = String(Int(aqi))
		self.aqiLabel.textColor = aqiScaleData.color
		
		// 2. Update air pollution level label
		self.airPollutionLevelLabel.text = aqiScaleData.airPollutionLevel.rawValue
		self.airPollutionLevelLabel.textColor = aqiScaleData.color
		
		// 3. Update air quality index progress slider
		let aqiProgress: CGFloat
		if(aqi > 300.0) {
			aqiProgress = 300.0
		}
		else {
			aqiProgress = CGFloat(aqi)
		}
		self.ringView.startProgress(to: aqiProgress, duration: 1)
	}
}

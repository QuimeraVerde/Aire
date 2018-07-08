//
//  GeoLocationSetup.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import CoreLocation

extension PageViewController: CLLocationManagerDelegate {
	func setupGeoLocation() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestAlwaysAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
			locationManager.startUpdatingLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			locationManager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if Location.sharedCoordinate.isEmpty() {
			if let location = locations.first {
				locationManager.stopUpdatingLocation()
				Location.sharedCoordinate.set(coordinate: location.coordinate)
				Location.sharedAddress.set(coordinate: location.coordinate)
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error:: \(error)")
	}
}

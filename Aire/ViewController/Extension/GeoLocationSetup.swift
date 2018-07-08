//
//  GeoLocationSetup.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
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
		if let location = locations.first {
			locationManager.stopUpdatingLocation()
			if !Location.sharedCoordinate.isEqual(to: location.coordinate) {
				Location.sharedCoordinate.set(coordinate: location.coordinate)
				lookUpCurrentLocation(completionHandler: {
					placemark in
					Location.sharedAddress.set(address: (placemark)!)
				})
			}
		}
	}
	
	func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
		-> Void ) {
		// Use the last reported location.
		if let lastLocation = self.locationManager.location {
			let geocoder = CLGeocoder()
			
			// Look up the location and pass it to the completion handler
			geocoder.reverseGeocodeLocation(lastLocation,
											completionHandler: { (placemarks, error) in
												if error == nil {
													let firstLocation = placemarks?[0]
													completionHandler(firstLocation)
												}
												else {
													// An error occurred during geocoding.
													completionHandler(nil)
												}
			})
		}
		else {
			// No location was available.
			completionHandler(nil)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error:: \(error)")
	}
}

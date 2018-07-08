//
//  Coordinate.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

struct Location {
	static let sharedCoordinate = Coordinate()	// Singleton
	static let sharedAddress = Address()		// Singleton

	struct Address {
		let variable = Variable<String>(String(""))
		var observable:Observable<String> {
			return variable.asObservable()
		}
		
		func set(coordinate: CLLocationCoordinate2D) {
			let location = coordinateToLocation(coordinate: coordinate)
			lookUp(location: location, completionHandler: {
				placemark in
				self.variable.value = (placemark?.name)!
			})
		}
		
		func coordinateToLocation(coordinate: CLLocationCoordinate2D) -> CLLocation{
			return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
		}
		
		private func lookUp(location: CLLocation, completionHandler: @escaping (CLPlacemark?)
			-> Void ) {
			let geocoder = CLGeocoder()
			
			// Look up the location and pass it to the completion handler
			geocoder.reverseGeocodeLocation(location,
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
	}

	class Coordinate {
		let variable = Variable<CLLocationCoordinate2D>(CLLocationCoordinate2D())
		var isReady: Bool = false
		var observable:Observable<CLLocationCoordinate2D> {
			return variable.asObservable()
		}
		func set(coordinate: CLLocationCoordinate2D) {
			self.isReady = true
			variable.value = coordinate
		}
		func isEqual(to: CLLocationCoordinate2D) -> Bool {
			return self.variable.value.latitude.isEqual(to: to.latitude) && self.variable.value.longitude.isEqual(to: to.longitude)
		}
	}
}


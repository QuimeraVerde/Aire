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
		func set(address: CLPlacemark) {
			variable.value = address.name!
		}
	}
	struct Coordinate {
		let variable = Variable<CLLocationCoordinate2D>(CLLocationCoordinate2D())
		var observable:Observable<CLLocationCoordinate2D> {
			return variable.asObservable()
		}
		func set(coordinate: CLLocationCoordinate2D) {
			variable.value = coordinate
		}
		func isEqual(to: CLLocationCoordinate2D) -> Bool {
			return self.variable.value.latitude.isEqual(to: to.latitude) && self.variable.value.longitude.isEqual(to: to.longitude)
		}
	}
}


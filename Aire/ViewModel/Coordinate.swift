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

struct Coordinate {
	static let sharedCoordinate = Coordinate() // Singleton
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

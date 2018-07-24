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

extension MapViewController {
	func setupAPISubscription() {
		let _ = selectCoordinateButton.rx.tap
			.map { _ in
				Location.sharedCoordinate.set(coordinate: self.pointAnnotation.coordinate)
				Location.sharedAddress.set(coordinate: self.pointAnnotation.coordinate)
			}
			.bind(onNext: { (aqi) in
				self.selectCoordinateButton.isEnabled = false
				self.selectCoordinateButton.alpha = 0.0
				let pageViewController = self.parent as! PageViewController
				pageViewController.prevPage()
			})
	}
}

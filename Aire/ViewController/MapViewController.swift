//
//  MapViewController.swift
//  Aire
//
//  Created by Natalia García on 7/7/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit
import RxSwift

class MapViewController: UIViewController {
	let locationManager = CLLocationManager()
	let pointAnnotation = MKPointAnnotation()

	private let disposeBag = DisposeBag()
	@IBOutlet weak var backToHomeButton: UIImageView!
	@IBOutlet weak var currentLocationButton: UIImageView!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var selectCoordinateButton: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.addAnnotation(pointAnnotation)
		selectLocationOnMap()
		setupBackToHomeButton()
		setupSelectCoordinateButton()
		setupCurrentLocationButton()
		setupGeoLocation()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.selectCoordinateButton.isHidden = true
		self.pointAnnotation.coordinate = Location.sharedCoordinate.variable.value
	}
	
	private func setupBackToHomeButton() {
		let tap = UITapGestureRecognizer()
		self.backToHomeButton.addGestureRecognizer(tap)
		tap.rx.event.bind(onNext: { recognizer in
			let pageViewController = self.parent as! PageViewController
			pageViewController.prevPage()
		}).disposed(by: disposeBag)
	}
	
	private func setupCurrentLocationButton() {
		let tap = UITapGestureRecognizer()
		self.currentLocationButton.addGestureRecognizer(tap)
		tap.rx.event.bind(onNext: { recognizer in
			self.locationManager.requestLocation()
		}).disposed(by: disposeBag)
	}
	
	private func selectedCoordinateIsCurrent() -> Bool {
		return Location.Coordinate.areEqual(a: pointAnnotation.coordinate,
											b: (self.locationManager.location?.coordinate)!)
	}
	
	private func centerCoordinateIsCurrent() -> Bool {
		return Location.Coordinate.areEqual(a: mapView.centerCoordinate,
											b: (self.locationManager.location?.coordinate)!)
	}
	
	func setupSelectCoordinateButton() {
		let tap = UITapGestureRecognizer()
		selectCoordinateButton.addGestureRecognizer(tap)
		tap.rx.event
			.map { _ in
				Location.sharedCoordinate.set(coordinate: self.pointAnnotation.coordinate)
				Location.sharedAddress.set(coordinate: self.pointAnnotation.coordinate)
			}
			.bind(onNext: { _ in
				let pageViewController = self.parent as! PageViewController
				pageViewController.prevPage()
			})
			.disposed(by: disposeBag)
	}
	
	func selectLocationOnMap() {
		let longPress = UILongPressGestureRecognizer()
		mapView.addGestureRecognizer(longPress)
		
		longPress.rx.event.bind(onNext: { recognizer in
			let touchedAt = recognizer.location(in: self.mapView)
			self.pointAnnotation.coordinate = self.mapView.convert(touchedAt, toCoordinateFrom: self.mapView)
			self.selectCoordinateButton.isHidden = false
		}).disposed(by: disposeBag)
	}
	
	func setupGeoLocation() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension MapViewController : CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			locationManager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			let span = MKCoordinateSpanMake(0.25, 0.25)
			let region = MKCoordinateRegion(center: location.coordinate, span: span)
			mapView.setRegion(region, animated: true)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error:: \(error)")
	}
}

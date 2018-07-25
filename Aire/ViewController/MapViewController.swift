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
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var selectCoordinateButton: UIButton!
	@IBOutlet weak var currentLocationButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.addAnnotation(pointAnnotation)
		selectLocationOnMap()
		setupSelectCoordinateButton()
		setupGeoLocation()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		disableButton(button: selectCoordinateButton)
		if selectedCoordinateIsCurrent(), centerCoordinateIsCurrent() {
			disableButton(button: currentLocationButton)
		}
	}
	
	private func disableButton(button: UIButton) {
		button.isEnabled = false
		button.alpha = 0.0
	}
	
	private func enableButton(button: UIButton) {
		button.isEnabled = true
		button.alpha = 1.0
	}

	private func selectedCoordinateIsCurrent() -> Bool {
		return Location.Coordinate.areEqual(a: pointAnnotation.coordinate,
											b: (self.locationManager.location?.coordinate)!)
	}
	
	private func centerCoordinateIsCurrent() -> Bool {
		return Location.Coordinate.areEqual(a: mapView.centerCoordinate,
											b: (self.locationManager.location?.coordinate)!)
	}
	
	@IBAction func showCurrentLocation(_ sender: Any) {
		locationManager.requestLocation()
		disableButton(button: currentLocationButton)
	}

	func setupSelectCoordinateButton() {
		let _ = selectCoordinateButton.rx.tap
			.map { _ in
				Location.sharedCoordinate.set(coordinate: self.pointAnnotation.coordinate)
				Location.sharedAddress.set(coordinate: self.pointAnnotation.coordinate)
			}
			.bind(onNext: { _ in
				self.disableButton(button: self.selectCoordinateButton)
				
				let pageViewController = self.parent as! PageViewController
				pageViewController.prevPage()
			})
	}
	
	func selectLocationOnMap() {
		let longPress = UILongPressGestureRecognizer()
		mapView.addGestureRecognizer(longPress)
		
		longPress.rx.event.bind(onNext: { recognizer in
			
			let touchedAt = recognizer.location(in: self.mapView)
			let touchedAtCoordinate : CLLocationCoordinate2D = self.mapView.convert(touchedAt, toCoordinateFrom: self.mapView)
			
			self.pointAnnotation.coordinate = touchedAtCoordinate
			self.enableButton(button: self.selectCoordinateButton)
			if !self.selectedCoordinateIsCurrent() {
				self.enableButton(button: self.currentLocationButton)
			}
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
			let span = MKCoordinateSpanMake(0.05, 0.05)
			let region = MKCoordinateRegion(center: location.coordinate, span: span)
			mapView.setRegion(region, animated: true)
			pointAnnotation.coordinate = location.coordinate
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error:: \(error)")
	}
}

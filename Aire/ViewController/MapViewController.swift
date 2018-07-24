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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupGestureRecognizer()
		setupSelectCoordinateButton()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		selectCoordinateButton.isEnabled = false
		setupGeoLocation()
	}
	
	func setupSelectCoordinateButton() {
		let _ = selectCoordinateButton.rx.tap
			.map { _ in
				Location.sharedCoordinate.set(coordinate: self.pointAnnotation.coordinate)
				Location.sharedAddress.set(coordinate: self.pointAnnotation.coordinate)
			}
			.bind(onNext: { _ in
				self.selectCoordinateButton.isEnabled = false
				self.selectCoordinateButton.alpha = 0.0
				let pageViewController = self.parent as! PageViewController
				pageViewController.prevPage()
			})
	}
	
	func setupGestureRecognizer() {
		let longPress = UILongPressGestureRecognizer()
		mapView.addGestureRecognizer(longPress)
		longPress.rx.event.bind(onNext: { recognizer in
			let touchedAt = recognizer.location(in: self.mapView) // adds the location on the view it was pressed
			let touchedAtCoordinate : CLLocationCoordinate2D = self.mapView.convert(touchedAt, toCoordinateFrom: self.mapView) // will get coordinates
			self.addPinWithCoordinate(coordinate: touchedAtCoordinate)
		}).disposed(by: disposeBag)
	}
	
	func setupGeoLocation() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
	}
	
	func addPinWithCoordinate(coordinate: CLLocationCoordinate2D) {
		pointAnnotation.coordinate = coordinate
		if(mapView.annotations.count > 0) {
			mapView.removeAnnotations(mapView.annotations)
		}
		selectCoordinateButton.isEnabled = true
		selectCoordinateButton.alpha = 1.0
		mapView.addAnnotation(pointAnnotation)
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
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error:: \(error)")
	}
}

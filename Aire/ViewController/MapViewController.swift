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

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var selectLocationButton: UIButton!
	
	private let disposeBag = DisposeBag()
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.addAnnotation(pointAnnotation)
		selectLocationOnMap()
		setupGeoLocation()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.selectLocationButton.isHidden = true
		self.pointAnnotation.coordinate = Location.sharedCoordinate.variable.value
	}
	
	private func goBack() {
		let pageViewController = self.parent as! PageViewController
		pageViewController.prevPage()
	}
	
	@IBAction func goBack(_ sender: Any) {
		self.goBack()
	}
	
	@IBAction func selectLocation(_ sender: Any) {
		Location.sharedCoordinate.update(coordinate: self.pointAnnotation.coordinate)
		Location.sharedAddress.update()
		
		self.goBack()
	}
	
	@IBAction func showCurrentLocation(_ sender: Any) {
		self.locationManager.requestLocation()
	}

	private func selectedCoordinateIsCurrent() -> Bool {
		return Location.Coordinate.areEqual(a: pointAnnotation.coordinate,
											b: (self.locationManager.location?.coordinate)!)
	}
	
	private func centerCoordinateIsCurrent() -> Bool {
		return Location.Coordinate.areEqual(a: mapView.centerCoordinate,
											b: (self.locationManager.location?.coordinate)!)
	}
	
	func selectLocationOnMap() {
		//let longPress = UILongPressGestureRecognizer()
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 1
		mapView.addGestureRecognizer(doubleTap)
		
		doubleTap.rx.event.bind(onNext: { recognizer in
			let touchedAt = recognizer.location(in: self.mapView)
			self.pointAnnotation.coordinate = self.mapView.convert(touchedAt, toCoordinateFrom: self.mapView)
			self.selectLocationButton.isHidden = false
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
			let span = MKCoordinateSpan.init(latitudeDelta: 0.25, longitudeDelta: 0.25)
			let region = MKCoordinateRegion(center: location.coordinate, span: span)
			mapView.setRegion(region, animated: true)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error:: \(error)")
	}
}

//
//  ViewController.swift
//  Aire
//
//  Created by Pau Escalante on 6/21/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift
import UIKit

class HomeViewController: UIViewController {
	@IBOutlet var addressLabel: UILabel!
	@IBOutlet var airQualityMeter: AirQualityMeter!
	@IBOutlet var fullReportAlert: FullAirQualityReportAlert!
    @IBOutlet var lastUpdated: UILabel!
    @IBOutlet var loadingIcon: UIActivityIndicatorView!
	@IBOutlet var mapButton: UIView!
	@IBOutlet var pollutantCardView: PollutantCardView!
	@IBOutlet var refreshButton: UIView!
	@IBOutlet var sceneView: SceneView!

	private let disposeBag = DisposeBag()
	private var pollutants: Dictionary<PollutantIdentifier, Pollutant>!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder() // To get shake gesture
		self.setupMapButton()
		self.setupRefreshButton()
		self.setupLocationSubscription()
		self.setupSceneViewSubscriptions()
		self.setupAirQualityMeter()
    }
	
	private func callApi() {
		let coordinate = Location.sharedCoordinate.variable.value
		self.callApi(coordinate: coordinate)
	}
	
	private func callApi(coordinate: CLLocationCoordinate2D) {
		let AirQualityAPI = DefaultAirQualityAPI.sharedAPI
		self.loadingIcon.startAnimating()
		AirQualityAPI.report(coordinate: coordinate)
		.bind(onNext: { (aqReport: AirQualityReport) in
			self.updateAirQualityData(aqReport: aqReport)
		}).disposed(by: self.disposeBag)
	}
	
	private func setupAirQualityMeter() {
		// Set tap gesture on aq meter
		let tap = UITapGestureRecognizer()
		self.airQualityMeter.addGestureRecognizer(tap)
		tap.rx.event
		.bind(onNext: { recognizer in
			self.fullReportAlert.show()
		}).disposed(by: disposeBag)
	}

	private func setupLocationSubscription() {
		// Address
		Location.sharedAddress.observable
		.subscribe(onNext:  { [weak self] address in
			DispatchQueue.main.async {
				self?.addressLabel.text = address
			}
		}).disposed(by: self.disposeBag)
		
		// Coordinate
		Location.sharedCoordinate.observable
		.bind(onNext: { coordinate in
			self.callApi(coordinate: coordinate)
		})
		.disposed(by: self.disposeBag)
	}
	
	private func setupMapButton() {
		let tap = UITapGestureRecognizer()
		self.mapButton.addGestureRecognizer(tap)
		tap.rx.event
		.bind(onNext: { _ in
			let pageViewController = self.parent as! PageViewController
			pageViewController.nextPage()
		})
		.disposed(by: disposeBag)
	}
	
	private func setupRefreshButton() {
		let tap = UITapGestureRecognizer()
		self.refreshButton.addGestureRecognizer(tap)
		
		tap.rx.event
		.bind(onNext: { _ in
			self.callApi()
		})
		.disposed(by: self.disposeBag)
	}
	
	private func setupSceneViewSubscriptions() {
		sceneView.selectedPollutantID
		.subscribe(onNext: { pollutantID in
			if pollutantID != nil, let pollutant = self.pollutants[pollutantID!] {
				self.pollutantCardView.update(pollutant: pollutant)
				self.pollutantCardView.show()
			}
			else {
				self.pollutantCardView.hide()
			}
		})
		.disposed(by: disposeBag)
		
		sceneView.loading
		.subscribe(onNext: { loading in
			if loading! {
				self.loadingIcon.startAnimating()
			}
			else {
				self.loadingIcon.stopAnimating()
			}
		})
		.disposed(by: disposeBag)
	}
	
	private func updateAirQualityData(aqReport: AirQualityReport) {
		self.pollutants = aqReport.pollutants
		self.updateTimestamp(aqReport.timestamp)
		self.airQualityMeter.update(aqi: aqReport.aqi)
		self.sceneView.createPollutants(pollutants: aqReport.pollutants)
		self.fullReportAlert.update(pollutants: aqReport.pollutants,
									dominantID: aqReport.dominantPollutantID)
	}
	
	private func updateTimestamp(_ timestamp: Date){
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"
		lastUpdated.text = "Última actualizacion: " + dateFormatter.string(from: timestamp)
	}
}

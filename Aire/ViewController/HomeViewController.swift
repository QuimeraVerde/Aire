//
//  ViewController.swift
//  Aire
//
//  Created by Pau Escalante on 6/21/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import ARKit
import UIKit
import UICircularProgressRing
import SceneKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
	@IBOutlet var addressLabel: UILabel!
	@IBOutlet var airQualityMeter: AirQualityMeter!
	@IBOutlet var fullReportAlert: FullAirQualityReportAlert!
    @IBOutlet var lastUpdated: UILabel!
    @IBOutlet var loadingIcon: UIActivityIndicatorView!
	@IBOutlet var mapButton: UIView!
	@IBOutlet var pollutantCardView: PollutantCardView!
	@IBOutlet var sceneView: SceneView!

	private let disposeBag = DisposeBag()
	private var pollutants: Dictionary<PollutantIdentifier, Pollutant>!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder() // To get shake gesture
		self.setupMapButton()
		self.setupLocationSubscription()
		self.setupSceneViewSubscriptions()
		self.setupAirQualityMeter()
		self.hideModals()
    }
	
	private func setupMapButton() {
		let tap = UITapGestureRecognizer()
		self.mapButton.addGestureRecognizer(tap)
		tap.rx.event.bind(onNext: { _ in
			let pageViewController = self.parent as! PageViewController
			pageViewController.nextPage()
		})
		.disposed(by: disposeBag)
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
	
	private func hideModals() {
		self.fullReportAlert.hide()
		self.pollutantCardView.hide()
	}
	
	private func setupAirQualityMeter() {
		// Set tap gesture on aq meter
		let tap = UITapGestureRecognizer()
		self.airQualityMeter.addGestureRecognizer(tap)
		tap.rx.event.bind(onNext: { recognizer in
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
		let AirQualityAPI = DefaultAirQualityAPI.sharedAPI
		Location.sharedCoordinate.observable.map{ coord in AirQualityAPI.report(coord) }
			.concat()
			.map { $0 }
			.bind(onNext: { (aqReport: AirQualityReport) in
				self.updateAirQualityData(aqReport: aqReport)
			}).disposed(by: disposeBag)
	}
	
	private func updateAirQualityData(aqReport: AirQualityReport) {
		self.pollutants = aqReport.pollutants
		self.updateTimestamp(timestamp: aqReport.timestamp)
		self.airQualityMeter.update(aqi: aqReport.aqi)
		self.sceneView.createPollutants(pollutants: aqReport.pollutants)
		self.fullReportAlert.update(pollutants: aqReport.pollutants,
									dominantID: aqReport.dominantPollutantID)
	}
	
	private func updateTimestamp(timestamp: Date){
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"
		lastUpdated.text = "Última actualizacion: " + dateFormatter.string(from: timestamp)
	}
}


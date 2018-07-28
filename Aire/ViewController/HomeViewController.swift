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
    @IBOutlet var lastUpdated: UILabel!
    @IBOutlet var loadingIcon: UIActivityIndicatorView!
	@IBOutlet var mapButton: UIView!
	@IBOutlet var sceneView: SceneView!

	private var airQualityMeter: AirQualityMeter!
	private var fullReportAlert: FullAirQualityReportAlert!
	private var pollutantCardView: PollutantCardView!

	private let disposeBag = DisposeBag()
	
	private var width: CGFloat!
	private var height: CGFloat!
	private let margin: CGFloat = 25.0
	
	private var pollutants: Dictionary<PollutantIdentifier, Pollutant>!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder() // To get shake gesture
		self.width = self.view.frame.size.width
		self.height = self.view.frame.size.height
		self.setupMapButton()
		self.setupLocationSubscription()
		self.setupSceneViewSubscriptions()
		self.addAirQualityMeter()
		self.addFullReportAlert()
		self.addPollutantCardView()
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
	
	private func addFullReportAlert() {
		fullReportAlert = FullAirQualityReportAlert(frame: self.view.frame)
		fullReportAlert.hide()
		self.view.addSubview(fullReportAlert)
	}
	
	private func addPollutantCardView() {
		let cardWidth = (self.width / 2) - (self.margin * 2)
		let cardHeight = self.height - (self.margin * 2)
		let pollutantCardRect = CGRect(x: self.margin,
									   y: self.margin,
									   width: cardWidth,
									   height: cardHeight)
		
		pollutantCardView = PollutantCardView(frame: pollutantCardRect)
		pollutantCardView.hide()
		self.view.addSubview(pollutantCardView)
	}
	
	private func addAirQualityMeter() {
		let aqMeterRect = CGRect(x: self.width-176,
								 y: self.height-176,
								 width: 176,
								 height: 176)
		airQualityMeter = AirQualityMeter(frame: aqMeterRect)
		self.view.addSubview(airQualityMeter)
		
		// Set tap gesture on aq meter
		let tap = UITapGestureRecognizer()
		self.airQualityMeter.addGestureRecognizer(tap)
		tap.rx.event.bind(onNext: { recognizer in
			self.fullReportAlert.show()
		}).disposed(by: disposeBag)
	}

	private func setupLocationSubscription() {
		setupCoordinateSubscription()
		setupAddressSubscription()
	}
	
	private func setupAddressSubscription() {
		Location.sharedAddress.observable.subscribe(onNext:  { [weak self] address in
			DispatchQueue.main.async {
				self?.addressLabel.text = address
			}
		}).disposed(by: self.disposeBag)
	}
	
	private func setupCoordinateSubscription() {
		let AirQualityAPI = DefaultAirQualityAPI.sharedAPI
		let _ = Location.sharedCoordinate.observable.map{ coord in AirQualityAPI.report(coord) }
			.concat()
			.map { $0 }
			.bind(onNext: { (aqReport: AirQualityReport) in
				self.updateAirQualityData(aqReport: aqReport)
			})
	}
	
	private func updateAirQualityData(aqReport: AirQualityReport) {
		self.pollutants = aqReport.pollutants
		self.updateTimestamp(timestamp: aqReport.timestamp)
		self.airQualityMeter.update(aqi: aqReport.aqi)
		self.sceneView.createPollutants(pollutants: aqReport.pollutants)
		self.fullReportAlert.update(pollutants: aqReport.pollutants, dominantID: aqReport.dominantPollutantID)
	}
	
	private func updateTimestamp(timestamp: Date){
		let dateFormatterGet = DateFormatter()
		dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm a"
		lastUpdated.text?.append(dateFormatterGet.string(from: timestamp))
	}
}


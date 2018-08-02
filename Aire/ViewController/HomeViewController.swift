//
//  ViewController.swift
//  Aire
//
//  Created by Pau Escalante on 6/21/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import CoreLocation
import Reachability
import RxCocoa
import RxSwift
import UIKit

class HomeViewController: UIViewController {
	@IBOutlet var airQualityMeter: AirQualityMeter!
	@IBOutlet var airQualityMeterButton: UIViewButton!
	@IBOutlet var fullReportAlert: FullAirQualityReportAlert!
    @IBOutlet var lastUpdated: UILabel!
    @IBOutlet var loadingIcon: UIActivityIndicatorView!
	@IBOutlet var mapButton: UIButton!
	@IBOutlet var networkErrorButton: UIButton!
	@IBOutlet var pollutantCardView: PollutantCardView!
	@IBOutlet var refreshButton: UIButton!
	@IBOutlet var sceneView: SceneView!
	
	private let disposeBag = DisposeBag()
	private var pollutants: Dictionary<PollutantIdentifier, Pollutant>!
	private var reachability: Reachability!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder() // To get shake gesture
		self.setTapGestures()
		self.setupLocationSubscription()
		self.setupNetworkManager()
		self.setupSceneViewSubscriptions()
    }

	private func callApi() {
		let coordinate = Location.sharedCoordinate.variable.value
		let AirQualityAPI = DefaultAirQualityAPI.sharedAPI
		
		self.loadingIcon.startAnimating()
		
		AirQualityAPI.report(coordinate: coordinate)
		.bind(onNext: { (aqReport: AirQualityReport) in
			self.updateAirQualityData(aqReport: aqReport)
		}).disposed(by: self.disposeBag)
	}
	
	private func setupNetworkManager() {
		let network = NetworkManager.shared
		network.reachability.whenUnreachable = { _ in
			self.networkErrorButton.isHidden = false
			
			self.mapButton.isEnabled = false
			self.refreshButton.isEnabled = false
		}
		network.reachability.whenReachable = { _ in
			self.networkErrorButton.isHidden = true
			Location.sharedAddress.update()
			self.callApi()
			
			self.mapButton.isEnabled = true
			self.refreshButton.isEnabled = true
		}
	}
	
	@IBAction func goToMap(_ sender: Any) {
		let pageViewController = self.parent as! PageViewController
		pageViewController.nextPage()
	}
	
	@IBAction func refresh(_ sender: Any) {
		self.callApi()
	}

	private func setTapGestures() {
		// AQ Meter button
		self.airQualityMeterButton.onTap = { _ in
			self.fullReportAlert.show()
		}
	}

	private func setupLocationSubscription() {
		// Address
		Location.sharedAddress.observable
			.bind(onNext: { address in
				self.mapButton.setTitle(address, for: .normal)
		}).disposed(by: self.disposeBag)
		
		// Coordinate
		Location.sharedCoordinate.observable
		.bind(onNext: { _ in
			NetworkManager.isReachable(completed: { _ in
				self.callApi()
			})
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

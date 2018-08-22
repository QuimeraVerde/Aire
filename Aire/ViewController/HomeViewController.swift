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
	@IBOutlet var networkErrorAlert: UIView!
	@IBOutlet var pollutantCardView: PollutantCardView!
	@IBOutlet var refreshButton: UIButton!
	@IBOutlet var sceneView: SceneView!
	
	private let disposeBag = DisposeBag()
	private var pollutants: Dictionary<PollutantIdentifier, Pollutant>!
	private var isConnected: Bool = false {
		didSet {
			if self.isConnected {
				self.networkErrorAlert.isHidden = true
				self.mapButton.isEnabled = true
				self.refreshButton.isEnabled = true
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder() // To get shake gesture
		self.initIsConnected()
		self.setLocationSubscription()
		self.setNetworkReachabilitySubscription()
		self.setSceneViewSubscriptions()
		self.setTapGestures()
    }
	
	// IBActions
	@IBAction func goToMap(_ sender: Any) {
		let pageViewController = self.parent as! PageViewController
		pageViewController.nextPage()
	}
	
	@IBAction func refresh(_ sender: Any) {
		self.callApi()
	}
	
	// Action functions
	private func callApi() {
		let coordinate = Location.sharedCoordinate.variable.value
		let AirQualityAPI = DefaultAirQualityAPI.sharedAPI
		
		self.loadingIcon.startAnimating()
		
		if self.isConnected {
			AirQualityAPI.report(coordinate: coordinate)
				.bind(onNext: { (aqReport: AirQualityReport) in
					self.updateAirQualityData(aqReport: aqReport)
				}).disposed(by: self.disposeBag)
		}
		else {
			self.updateAirQualityData(aqReport: AirQualityReportTest())
		}
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

	// Setup functions
	private func initIsConnected() {
		NetworkManager.isReachable(completed: { _ in
			self.isConnected = true
		})
	}
	
	private func setLocationSubscription() {
		// Address
		Location.sharedAddress.observable
			.bind(onNext: { address in
				self.mapButton.setTitle(address, for: .normal)
			}).disposed(by: self.disposeBag)
		
		// Coordinate
		Location.sharedCoordinate.observable
			.bind(onNext: { _ in
				if self.isConnected {
					self.callApi()
				}
			})
			.disposed(by: self.disposeBag)
	}
	
	private func setNetworkReachabilitySubscription() {
		let network = NetworkManager.shared
		network.reachability.whenUnreachable = { _ in
			self.isConnected = false
		}
		network.reachability.whenReachable = { _ in
			self.isConnected = true
			Location.sharedAddress.update()
			self.callApi()
		}
	}
	
	private func setSceneViewSubscriptions() {
		// Listen for a selected pollutant
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
		
		// Listen for when loading stops
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
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.handleShakeGesture()
        }
    }
    
    func handleShakeGesture(){
        self.sceneView.removePollutants()
        self.pollutantCardView.hide()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(500), execute: {
            self.sceneView.createPollutants(pollutants: self.pollutants)
        })
    }
	
	private func setTapGestures() {
		// AQ Meter button
		self.airQualityMeterButton.onTap = { _ in
			self.fullReportAlert.show()
		}
	}
}

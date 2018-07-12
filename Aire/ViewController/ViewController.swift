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

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
	@IBOutlet var pollutantLabel: UILabel!
	@IBOutlet var pollutantCard: UIView!
	@IBOutlet var SegmentedMenu: UISegmentedControl!
    @IBOutlet var pollutantGif: UIImageView!
    @IBOutlet var pollutantCircleImage: UIImageView!
    @IBOutlet var labelAQILevelPollutant: UILabel!
    @IBOutlet var lastUpdated: UILabel!
	@IBOutlet var addressLabel: UILabel!
	@IBOutlet var mapButton: UIButton!
    
    @IBOutlet var loadingIcon: UIActivityIndicatorView!
    
    @IBOutlet var PollutantText0: UITextView!
    @IBOutlet var PollutantText1: UITextView!
    @IBOutlet var PollutantText2: UITextView!

	var fullReportAlert: FullAirQualityReportAlert!
	var airQualityMeter: AirQualityMeter!
    
    var pollutantsInfo: Dictionary<PollutantIdentifier, Pollutant> = Dictionary<PollutantIdentifier,Pollutant>()
    var dominantPollutant: PollutantIdentifier!
    var selectedPollutant: PollutantIdentifier!

	let disposeBag = DisposeBag()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder() // To get shake gesture
		self.setupLocationSubscription()
		self.setupScene()
    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupARConfiguration()
		setupPollutantCard()
		
		self.addAirQualityMeter()
		self.setFullReportAlert()
    }
	
	private func setFullReportAlert() {
		self.addFullReportAlert()
		self.setShowFullReportButton()
	}
	
	private func addFullReportAlert() {
		fullReportAlert = FullAirQualityReportAlert(frame: self.view.frame)
		self.view.addSubview(fullReportAlert)
	}
	
	private func addAirQualityMeter() {
		let aqMeterRect = CGRect(x: self.view.frame.size.width-176, y: self.view.frame.size.height-176, width: 176, height: 176)
		airQualityMeter = AirQualityMeter(frame: aqMeterRect)
		self.view.addSubview(airQualityMeter)
	}
	
	@objc private func handleTap(_: UITapGestureRecognizer? = nil) {
		self.fullReportAlert.show()
	}
	
	private func setShowFullReportButton() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		self.airQualityMeter.addGestureRecognizer(tap)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


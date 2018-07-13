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
    @IBOutlet var lastUpdated: UILabel!
	@IBOutlet var addressLabel: UILabel!
	@IBOutlet var mapButton: UIButton!
    
    @IBOutlet var loadingIcon: UIActivityIndicatorView!

	var fullReportAlert: FullAirQualityReportAlert!
	var airQualityMeter: AirQualityMeter!
	var pollutantCardView: PollutantCardView!
    
    var pollutantsInfo: Dictionary<PollutantIdentifier, Pollutant> = Dictionary<PollutantIdentifier,Pollutant>()
    var dominantPollutant: PollutantIdentifier!
    var selectedPollutant: PollutantIdentifier!

	let disposeBag = DisposeBag()
	
	private var width: CGFloat!
	private var height: CGFloat!
	private let margin: CGFloat = 25.0
	
	/*required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
	}*/

	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder() // To get shake gesture
		self.width = self.view.frame.size.width
		self.height = self.view.frame.size.height
		self.setupLocationSubscription()
		self.setupScene()
		self.addPollutantCardView()
		self.addAirQualityMeter()
		self.setFullReportAlert()
    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupARConfiguration()
    }
	
	private func setFullReportAlert() {
		self.addFullReportAlert()
		self.setShowFullReportButton()
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
	}
	
	@objc private func showFullReport(_: UITapGestureRecognizer? = nil) {
		self.fullReportAlert.show()
	}
	
	private func setShowFullReportButton() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.showFullReport(_:)))
		self.airQualityMeter.addGestureRecognizer(tap)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


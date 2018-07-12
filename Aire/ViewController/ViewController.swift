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

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
	@IBOutlet weak var aqiLabel: UILabel!
	@IBOutlet weak var airPollutionLevelLabel: UILabel!
	@IBOutlet weak var ringView: UICircularProgressRing!
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
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		// Air quality full report
		fullReportAlert = FullAirQualityReportAlert(frame: self.view.frame)
		self.view.addSubview(fullReportAlert)
	}
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupARConfiguration()
		setupProgressRing()
		setupPollutantCard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


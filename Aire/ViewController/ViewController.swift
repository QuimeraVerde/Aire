//
//  ViewController.swift
//  Aire
//
//  Created by Pau Escalante on 6/21/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import ARKit
import CoreLocation
import UIKit
import UICircularProgressRing
import SceneKit

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
    
    @IBOutlet var mainPollutantLabel: UILabel!
    @IBOutlet var mainPollutantLevel: UILabel!
    @IBOutlet var mainPollutantRange: UIImageView!
    
    @IBOutlet var pollutantLabel1: UILabel!
    @IBOutlet var pollutantLevel1: UILabel!
    @IBOutlet var pollutantRange1: UIImageView!
    
    @IBOutlet var pollutantLabel2: UILabel!
    @IBOutlet var pollutantLevel2: UILabel!
    @IBOutlet var pollutantRange2: UIImageView!
    
    @IBOutlet var pollutantLabel3: UILabel!
    @IBOutlet var pollutantLevel3: UILabel!
    @IBOutlet var pollutantRange3: UIImageView!
    
    @IBOutlet var pollutantLabel4: UILabel!
    @IBOutlet var pollutantLevel4: UILabel!
    @IBOutlet var pollutantRange4: UIImageView!
    
    @IBOutlet var pollutantLabel5: UILabel!
    @IBOutlet var pollutantLevel5: UILabel!
    @IBOutlet var pollutantRange5: UIImageView!
    
    @IBOutlet var blurEffect: UIVisualEffectView!
    
    @IBOutlet var fullReportAlert: UIView!
    var pollutantsInfo: Dictionary<String, Pollutant> = Dictionary<String,Pollutant>()
    var dominantPollutant: String = ""
	
	let locationManager = CLLocationManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // To get shake gesture
        self.becomeFirstResponder()
		self.setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFullReportView()
        setupARConfiguration()
		setupProgressRing()
		setupCoordinateSubscription()
		setupPollutantCard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


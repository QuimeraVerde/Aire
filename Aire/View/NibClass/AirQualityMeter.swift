//
//  AirQualityMeter.swift
//  Aire
//
//  Created by Natalia García on 7/12/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UICircularProgressRing
import UIKit

class AirQualityMeter: NibView {
	@IBOutlet var indexLabel: UILabel!
	@IBOutlet var progressView: UICircularProgressRing!
	@IBOutlet var levelLabel: UILabel!
	
    @IBOutlet var smallIndexLabel: UILabel!
    override init(frame: CGRect) {
		super.init(frame: frame)
		self.initProgressView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.initProgressView()
	}
	
	func update(aqi: Double) {
		let aqiLevel = AirQualityScale.getLevelForIndex(index: aqi)
		
		self.indexLabel.text = String(Int(aqi))
		self.indexLabel.textColor = aqiLevel.color
        self.smallIndexLabel.text = String(Int(aqi))
        self.smallIndexLabel.textColor = aqiLevel.color
		
		self.levelLabel.text = aqiLevel.title.rawValue
		self.levelLabel.textColor = aqiLevel.color
		
		let aqiProgress: CGFloat
		if(aqi > 300.0) {
			aqiProgress = 300.0
		}
		else {
			aqiProgress = CGFloat(aqi)
		}
		self.progressView.startProgress(to: aqiProgress, duration: 1)
	}
	
	private func initProgressView() {
        
        if(self.view.frame.width < 768) {
            self.levelLabel.isHidden = true
            self.indexLabel.isHidden = true
            self.smallIndexLabel.isHidden = false
        }
        
        else {
            self.levelLabel.isHidden = false
            self.indexLabel.isHidden = false
            self.smallIndexLabel.isHidden = true
        }
        
		//values
		self.progressView.minValue = 0
		self.progressView.maxValue = 300
		//default value
		self.progressView.value = 0
		//colors
		self.progressView.ringStyle = .gradient
		self.progressView.gradientColors = [UIUtility.color.green,
								   UIUtility.color.yellow,
								   UIUtility.color.orange,
								   UIUtility.color.red,
								   UIUtility.color.crimson]
		self.progressView.gradientColorLocations = [0.0,
										   0.2,
										   0.4,
										   0.6,
										   0.8]
		self.progressView.gradientStartPosition = UICircularProgressRingGradientPosition.left
		self.progressView.gradientEndPosition = UICircularProgressRingGradientPosition.top
	}
}

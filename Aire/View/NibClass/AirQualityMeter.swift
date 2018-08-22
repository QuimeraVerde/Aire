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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initProgressView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.initProgressView()
	}
	
	func update(aqi: Double) {
		let aqiLevel = AirQualityUtility.generalAQILevel[aqi]
		
		self.indexLabel.text = String(Int(aqi))
		self.indexLabel.textColor = aqiLevel.color
		
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
		//values
		self.progressView.minValue = 0
		self.progressView.maxValue = 300

		//default value
		self.progressView.value = 0
	}
}

//
//  PollutantSummaryView.swift
//  Aire
//
//  Created by Natalia García on 7/10/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class PollutantCircleView: NibView {
	@IBOutlet var pollutantIndexLabel: UILabel!
	@IBOutlet var pollutantLevelView: CircleView!
	var isAnimating = false
	
	override func awakeFromNib() {
		super.awakeFromNib()
		if !isAnimating {
			self.pollutantIndexLabel.font = self.pollutantIndexLabel.font.withSize(frame.size.width * 22.0/75.0)
		}
	}
	
	func animate() {
		isAnimating = true
		self.pollutantLevelView.animate()
	}
	
	func stopAnimation() {
		isAnimating = false
		self.pollutantLevelView.stopAnimation()
	}
	
	func update(index: Double) {
		pollutantIndexLabel.text = String(index)
		pollutantLevelView.setBorderColor(AirQualityUtility.scale[index].color)
	}
	
	func update(pollutant: Pollutant) {
		pollutantIndexLabel.text = String(pollutant.aqi)
		pollutantLevelView.setBorderColor(AirQualityUtility.scale[pollutant.aqi].color)
	}
}

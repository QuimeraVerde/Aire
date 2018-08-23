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
	
	@IBInspectable var heading: Int = 0 {
		didSet {
			let newFont = self.pollutantIndexLabel.font.withSize(CGFloat(22 + (heading*2)))
			self.pollutantIndexLabel.font = newFont
			setNeedsDisplay()
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

	func update(aqi: Double) {
		pollutantIndexLabel.text = String(Int(ceil(aqi)))
		pollutantLevelView.setBorderColor(AirQualityScale.getLevelForIndex(index: aqi).color)
	}
}

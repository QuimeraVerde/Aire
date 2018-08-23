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
class PollutantSummaryView: NibView {
	@IBOutlet var pollutantTitleLabel: UILabel!
	@IBOutlet var pollutantCircle: PollutantCircleView!

	func update(pollutant: Pollutant) {
		self.pollutantTitleLabel.text = PollutantView.config[pollutant.id]!.title
		self.pollutantCircle.update(aqi: pollutant.aqi)
	}
	
	@IBInspectable var heading: Int = 0 {
		didSet {
			let newFont = self.pollutantTitleLabel.font.withSize(CGFloat(22 + (heading*2)))
			self.pollutantTitleLabel.font = newFont
			self.pollutantCircle.heading = self.heading
			setNeedsDisplay()
		}
	}
	
	@IBInspectable var pollutantTitle: String = "" {
		didSet {
			self.pollutantTitleLabel.text = self.pollutantTitle
		}
	}
}

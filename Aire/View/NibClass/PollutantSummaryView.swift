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

	func update(title: String, index: Double) {
		self.pollutantTitleLabel.text = title
		self.pollutantCircle.update(index: index)
	}
	
	func update(pollutant: Pollutant) {
		self.update(title: pollutant.title, index: pollutant.aqi)
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

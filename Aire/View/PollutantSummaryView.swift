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
	@IBOutlet var pollutantIndexLabel: UILabel!
	@IBOutlet var pollutantLevelView: CircleView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.pollutantIndexLabel.font = self.pollutantIndexLabel.font.withSize(frame.size.width * 22.0/75.0)
	}
	
	func update(pollutant: Pollutant) {
		pollutantTitleLabel.text = pollutant.title
		pollutantIndexLabel.text = String(pollutant.aqi)
		pollutantLevelView.layer.borderColor = AirQualityUtility.scale[pollutant.aqi].color.cgColor
	}
	
	@IBInspectable var heading: Int = 0 {
		didSet {
			switch(self.heading) {
			case 1:
				self.pollutantTitleLabel.font = self.pollutantIndexLabel.font.withSize(24)
			case 2:
				self.pollutantTitleLabel.font = self.pollutantIndexLabel.font.withSize(26)
			case 3:
				self.pollutantTitleLabel.font = self.pollutantIndexLabel.font.withSize(28)
			case 4:
				self.pollutantTitleLabel.font = self.pollutantIndexLabel.font.withSize(30)
			case 5:
				self.pollutantTitleLabel.font = self.pollutantIndexLabel.font.withSize(32)
			case 6:
				self.pollutantTitleLabel.font = self.pollutantIndexLabel.font.withSize(34)
			case 7:
				self.pollutantTitleLabel.font = self.pollutantIndexLabel.font.withSize(36)
			default:
				self.pollutantTitleLabel.font = self.pollutantIndexLabel.font.withSize(22)
			}
			setNeedsDisplay()
		}
	}
}

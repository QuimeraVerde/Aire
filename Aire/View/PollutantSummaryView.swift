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
			self.pollutantTitleLabel.font = self.pollutantIndexLabel.font.withSize(CGFloat(22 + (heading*2)))
			setNeedsDisplay()
		}
	}
}

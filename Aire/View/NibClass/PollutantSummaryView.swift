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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
    
    private func sharedInit() {
        let newSize = 0.28*self.pollutantCircle.frame.width
        let newFont = self.pollutantTitleLabel.font.withSize(newSize + CGFloat(self.heading*2))
        self.pollutantTitleLabel.font = newFont
    }

	func update(pollutant: Pollutant) {
        self.sharedInit()
		self.pollutantTitleLabel.text = PollutantView.config[pollutant.id]!.title
		self.pollutantCircle.update(aqi: pollutant.aqi)
	}
	
	@IBInspectable var heading: Int = 0 {
		didSet {
			sharedInit()
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

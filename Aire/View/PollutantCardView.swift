//
//  PollutantCardView.swift
//  Aire
//
//  Created by Natalia García on 7/12/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UIKit

class PollutantCardView: NibView {
	@IBOutlet weak var pollutantSummary: PollutantSummaryView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.layer.cornerRadius = 10
		self.layer.masksToBounds = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func show() {
		self.isHidden = false
	}
	
	func hide() {
		self.isHidden = true
	}
	
	@IBAction func hide(_ sender: Any) {
		self.hide()
	}
	
	func update(pollutant: Pollutant) {
		self.pollutantSummary.update(pollutant: pollutant)
	}
}

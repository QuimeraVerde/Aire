//
//  PollutantCardInfo.swift
//  Aire
//
//  Created by Natalia García on 7/9/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UIKit

class FullAirQualityReportAlert: NibView {
	@IBOutlet weak var pollutantSummariesTopContainer: UIView!
	@IBOutlet weak var pollutantSummariesBottomContainer: UIView!
	@IBOutlet weak var reportContainer: UIView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.sharedInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.sharedInit()
	}

	private func sharedInit() {
		self.reportContainer.center = self.center
	}
	
	func show() {
		self.isHidden = false
	}
	
	func hide() {
		self.isHidden = true
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch = touches.first
		if !(touch?.view?.isDescendant(of: self.reportContainer))! {
			self.hide()
		}
	}
	
	func update(
		pollutants: Dictionary<PollutantIdentifier, Pollutant>,
		dominantID: PollutantIdentifier) {
			let secondaryPollutantIDs = PollutantIdentifier.allCases
				.filter({ (pollutantID) -> Bool in
					pollutantID != dominantID
				})
		
			self.setTopPollutantSummaries(pollutants: pollutants,
										  dominantID: dominantID,
										  secondaryPollutantIDs:secondaryPollutantIDs)
		
			self.setBottomPollutantSummaries(pollutants: pollutants,
											 secondaryPollutantIDs: secondaryPollutantIDs)
	}
	
	// Private functions
	private func setTopPollutantSummaries(
		pollutants: Dictionary<PollutantIdentifier, Pollutant>,
		dominantID: PollutantIdentifier,
		secondaryPollutantIDs: [PollutantIdentifier]) {
			var pollutantSummaries = self.pollutantSummariesTopContainer
										.subviews as! [PollutantSummaryView]
		
			pollutantSummaries[0].update(pollutant: pollutants[secondaryPollutantIDs[0]]!)
			pollutantSummaries[1].update(pollutant: pollutants[dominantID]!)
			pollutantSummaries[2].update(pollutant: pollutants[secondaryPollutantIDs[1]]!)
	}
	
	private func setBottomPollutantSummaries(
		pollutants: Dictionary<PollutantIdentifier, Pollutant>,
		secondaryPollutantIDs: [PollutantIdentifier]) {
			var pollutantSummaries = self.pollutantSummariesBottomContainer
										.subviews as! [PollutantSummaryView]
		
			pollutantSummaries[0].update(pollutant: pollutants[secondaryPollutantIDs[2]]!)
			pollutantSummaries[1].update(pollutant: pollutants[secondaryPollutantIDs[3]]!)
			pollutantSummaries[2].update(pollutant: pollutants[secondaryPollutantIDs[4]]!)
	}
}

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
	@IBOutlet weak var pollutantSummariesTopContainer: UIStackView!
	@IBOutlet weak var pollutantSummariesBottomContainer: UIStackView!
	@IBOutlet weak var reportContainer: UIView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.isHidden = true
		self.reportContainer.center = self.center
		addTopPollutantSummaries()
		addBottomPollutantSummaries()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func show() {
		self.isHidden = false
	}
	
	@IBAction func hide(_ sender: Any) {
		self.isHidden = true
	}
	
	func setPollutantSummaries(
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
		
			pollutantSummaries[0].setPollutantSummary(pollutant: pollutants[secondaryPollutantIDs[0]]!)
			pollutantSummaries[1].setPollutantSummary(pollutant: pollutants[dominantID]!)
			pollutantSummaries[2].setPollutantSummary(pollutant: pollutants[secondaryPollutantIDs[1]]!)
	}
	
	private func setBottomPollutantSummaries(
		pollutants: Dictionary<PollutantIdentifier, Pollutant>,
		secondaryPollutantIDs: [PollutantIdentifier]) {
			var pollutantSummaries = self.pollutantSummariesBottomContainer
										.subviews as! [PollutantSummaryView]
		
			pollutantSummaries[0].setPollutantSummary(pollutant: pollutants[secondaryPollutantIDs[2]]!)
			pollutantSummaries[1].setPollutantSummary(pollutant: pollutants[secondaryPollutantIDs[3]]!)
			pollutantSummaries[2].setPollutantSummary(pollutant: pollutants[secondaryPollutantIDs[4]]!)
	}
	
	private func addTopPollutantSummaries() {
		for _ in 0...2 {
			let pollutantSummary = PollutantSummaryView(frame: self.frame)
			self.pollutantSummariesTopContainer
					.addArrangedSubview(pollutantSummary)
		}
	}
	
	private func addBottomPollutantSummaries() {
		for _ in 3...5 {
			let pollutantSummary = PollutantSummaryView(frame: self.frame)
			self.pollutantSummariesBottomContainer
					.addArrangedSubview(pollutantSummary)
		}
	}
}

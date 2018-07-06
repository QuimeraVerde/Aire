//
//  PollutantSetup.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
	func setupPollutantCard() {
		pollutantCard.layer.cornerRadius = 10
		pollutantCard.layer.masksToBounds = true
		SegmentedMenu.selectedSegmentIndex = 0
	}
	
	@IBAction func closeCard(_ sender: UIButton) {
		// hide card
		hideCard()
	}
	
	// load data on pollutant card and show
	func showCard(){
		pollutantCard.isHidden = false
	}
	
	// reset data on pollutant card and hide
	func hideCard(){
		pollutantCard.isHidden = true
		SegmentedMenu.selectedSegmentIndex = 0
	}
	
	func showPollutantInfo(pollutantName: String){
		if (PollutantUtility.config.model[pollutantName] != nil) {
			let pollutantConfig: ModelConfiguration = PollutantUtility.config.model[pollutantName]!
			pollutantLabel.text = pollutantConfig.fullName
			
			// unhide card
			showCard()
		}
	}
	
}

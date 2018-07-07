//
//  PollutantSetup.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UIKit
import SwiftGifOrigin

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
    func showCard(pollutant: ModelConfiguration){
        // show correct title
        pollutantLabel.text = pollutant.fullName
        
        // get aqi level from global variable
        // TODO
        let aqiLevel: Int = Int(ceil(pollutantsInfo[pollutant.title]!.aqi))
        labelAQILevelPollutant.text = String(aqiLevel)
        
        // create animation for range
        let animatedImage = AnimatedImage(title: "range" + pollutant.getRange(aqiValue: aqiLevel),
                                          count:20)
        pollutantCircleImage.animationImages = animatedImage.createImageArray()
        pollutantCircleImage.animationDuration = animatedImage.duration
        
        // loops forever
        pollutantCircleImage.animationRepeatCount = 0
        
        // content
        pollutantGif.image = UIImage.gif(name: "molecule")
        
        // show
        pollutantCard.isHidden = false
        
        // animate circle
        pollutantCircleImage.startAnimating()
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
			showCard(pollutant: pollutantConfig)
		}
	}
	
}

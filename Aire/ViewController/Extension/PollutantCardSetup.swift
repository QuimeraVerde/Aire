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
        // update selected
        selectedPollutant = pollutant.title
        
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
        
        // get content
        createPollutantContent(pollutantTitle: pollutant.title)
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
    
    func createPollutantContent(pollutantTitle: String){
        // get content for first card
        let content = PollutantContent(title: pollutantTitle)
        PollutantText0.text = content.getContentByIndex(index:0)
        
        // hide all except first
        PollutantText0.isHidden = false
        PollutantText1.isHidden = true
        PollutantText2.isHidden = true
    }
    
    // change segment
    @IBAction func changeSegment(_ sender: Any) {
        let selectedIndex: Int = SegmentedMenu.selectedSegmentIndex
        
        switch selectedIndex {
        case 0:
            // get content for first card
            let content = PollutantContent(title: selectedPollutant)
            PollutantText0.text = content.getContentByIndex(index:0)
            
            // hide all except first
            PollutantText0.isHidden = false
            PollutantText1.isHidden = true
            PollutantText2.isHidden = true
        case 1:
            // get content for first card
            let content = PollutantContent(title: selectedPollutant)
            PollutantText1.text = content.getContentByIndex(index:1)
            
            // hide all except first
            PollutantText0.isHidden = true
            PollutantText1.isHidden = false
            PollutantText2.isHidden = true
        case 2:
            // get content for first card
            let content = PollutantContent(title: selectedPollutant)
            PollutantText2.text = content.getContentByIndex(index:2)
            
            // hide all except first
            PollutantText0.isHidden = true
            PollutantText1.isHidden = true
            PollutantText2.isHidden = false
        default:
            break
        }
    }
}

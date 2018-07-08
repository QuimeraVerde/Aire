//
//  FullReportSetup.swift
//  Aire
//
//  Created by Pau Escalante on 7/7/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//
import Foundation
import UIKit
import SwiftGifOrigin

extension ViewController {
    
    func setupFullReportView(){
        fullReportAlert.isHidden = true
        blurEffect.isHidden = true
        
        fullReportAlert.layer.cornerRadius = 10
        fullReportAlert.layer.masksToBounds = true
    }
    
    func showFullReport(){
        var pollutantsReport = pollutantsInfo
        var pollutantConfig: ModelConfiguration
        var aqiLevel: Int

        // main pollutant
        if (pollutantsReport[dominantPollutant] != nil) {
            pollutantConfig = PollutantUtility.config.model[dominantPollutant]!
            aqiLevel = Int(ceil(pollutantsReport[dominantPollutant]!.aqi))

            mainPollutantLabel.text = pollutantsReport[dominantPollutant]?.title
            mainPollutantLevel.text = String(aqiLevel)
            mainPollutantRange.image = UIImage(named: "range" + pollutantConfig.getRange(aqiValue: aqiLevel))
        }
        
        pollutantsReport.removeValue(forKey: dominantPollutant)
        
        // other pollutants
        var namePollutant = pollutantsReport.first?.key
        pollutantConfig = PollutantUtility.config.model[namePollutant!]!
        aqiLevel = Int(ceil(pollutantsInfo[namePollutant!]!.aqi))
        
        pollutantLabel1.text = pollutantsInfo[namePollutant!]?.title
        pollutantLevel1.text = String(aqiLevel)
        pollutantRange1.image = UIImage(named: "range" + pollutantConfig.getRange(aqiValue: aqiLevel) + "-0")
        
        pollutantsReport.removeValue(forKey: namePollutant!)
        
        namePollutant = pollutantsReport.first?.key
        pollutantConfig = PollutantUtility.config.model[namePollutant!]!
        aqiLevel = Int(ceil(pollutantsInfo[namePollutant!]!.aqi))
        
        pollutantLabel2.text = pollutantsInfo[namePollutant!]?.title
        pollutantLevel2.text = String(aqiLevel)
        pollutantRange2.image = UIImage(named: "range" + pollutantConfig.getRange(aqiValue: aqiLevel) + "-0")
        
        pollutantsReport.removeValue(forKey: namePollutant!)
        
        namePollutant = pollutantsReport.first?.key
        pollutantConfig = PollutantUtility.config.model[namePollutant!]!
        aqiLevel = Int(ceil(pollutantsInfo[namePollutant!]!.aqi))
        
        pollutantLabel3.text = pollutantsInfo[namePollutant!]?.title
        pollutantLevel3.text = String(aqiLevel)
        pollutantRange3.image = UIImage(named: "range" + pollutantConfig.getRange(aqiValue: aqiLevel) + "-0")
        
        pollutantsReport.removeValue(forKey: namePollutant!)
        
        namePollutant = pollutantsReport.first?.key
        pollutantConfig = PollutantUtility.config.model[namePollutant!]!
        aqiLevel = Int(ceil(pollutantsInfo[namePollutant!]!.aqi))
        
        pollutantLabel4.text = pollutantsInfo[namePollutant!]?.title
        pollutantLevel4.text = String(aqiLevel)
        pollutantRange4.image = UIImage(named: "range" + pollutantConfig.getRange(aqiValue: aqiLevel) + "-0")
        
        pollutantsReport.removeValue(forKey: namePollutant!)
        
        namePollutant = pollutantsReport.first?.key
        pollutantConfig = PollutantUtility.config.model[namePollutant!]!
        aqiLevel = Int(ceil(pollutantsInfo[namePollutant!]!.aqi))
        
        pollutantLabel5.text = pollutantsInfo[namePollutant!]?.title
        pollutantLevel5.text = String(aqiLevel)
        pollutantRange5.image = UIImage(named: "range" + pollutantConfig.getRange(aqiValue: aqiLevel) + "-0")
        
        pollutantsReport.removeValue(forKey: namePollutant!)
        
        fullReportAlert.isHidden = false
        blurEffect.isHidden = false
    }

    @IBAction func closeReport(_ sender: Any) {
        fullReportAlert.isHidden = true
        blurEffect.isHidden = true
    }
}


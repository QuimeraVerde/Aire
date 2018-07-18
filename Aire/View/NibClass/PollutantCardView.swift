//
//  PollutantCardView.swift
//  Aire
//
//  Created by Natalia García on 7/12/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UIKit
import SwiftyMarkdown

enum PollutantContentIdentifier: String {
	case definition = "definition"
	case causes = "causes"
	case issues = "issues"
}

class PollutantCardView: NibView {
	@IBOutlet weak var pollutantSummary: PollutantSummaryView!
	@IBOutlet weak var segmentedMenu: UISegmentedControl!
	@IBOutlet weak var contentTextView: UITextView!
	
	private var content: Dictionary<PollutantIdentifier, Dictionary<PollutantContentIdentifier, UITextView>>!
    
    private var selectedPollutant : String!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.layer.cornerRadius = 10
		self.layer.masksToBounds = true
		self.segmentedMenu.selectedSegmentIndex = 0
        self.selectedPollutant = ""
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func show() {
		self.isHidden = false
	}
	
	func hide() {
		self.isHidden = true
        segmentedMenu.selectedSegmentIndex = 0
	}
	
	@IBAction func hide(_ sender: Any) {
		self.hide()
	}
    
    @IBAction func changeSegment(_ sender: Any) {
        let selectedIndex: Int = segmentedMenu.selectedSegmentIndex
        var selectedSection: String = PollutantContentIdentifier.definition.rawValue
        
        switch selectedIndex {
        case 0:
            selectedSection = PollutantContentIdentifier.definition.rawValue
        case 1:
            selectedSection = PollutantContentIdentifier.causes.rawValue
        case 2:
            selectedSection = PollutantContentIdentifier.issues.rawValue
        default:
            selectedSection = PollutantContentIdentifier.definition.rawValue
        }
        
        self.contentTextView.attributedText = self.getAttributedText(section: selectedSection)
    }
    
	func update(pollutant: Pollutant) {
        self.selectedPollutant = pollutant.id
		self.pollutantSummary.update(pollutant: pollutant)
        self.contentTextView.attributedText = self.getAttributedText(section: PollutantContentIdentifier.definition.rawValue)
	}
	
    private func getAttributedText(section: String) -> NSAttributedString {
        let fileName = self.selectedPollutant + "-" + section
		if let url = Bundle.main.url(forResource: fileName, withExtension: "md") {
			if let md = SwiftyMarkdown(url: url) {
				md.setFontNameForAllStyles(with: "Avenir-Roman")
				
				return md.attributedString()
				
			} else {
				fatalError("Error loading file")
			}
		} else {
			fatalError("Error loading file")
		}
	}
}

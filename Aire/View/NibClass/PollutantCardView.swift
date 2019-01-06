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

class PollutantCardView: NibView {
	enum SectionIdentifier: String {
		case definition
		case causes
		case issues
		
		static let allCases = [definition, causes, issues]
	}
	
	@IBOutlet weak var pollutantCircle: PollutantCircleView!
	@IBOutlet weak var pollutantTitle: UILabel!
	@IBOutlet weak var segmentedMenu: UISegmentedControl!
	@IBOutlet weak var contentTextView: UITextView!
    @IBOutlet var closeButton: UIViewButton!
    
    private var content: Dictionary<PollutantIdentifier, Dictionary<SectionIdentifier, UITextView>>!
    
    private var selectedPollutant: PollutantIdentifier = PollutantIdentifier()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.sharedInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.sharedInit()
	}
	
	func sharedInit() {
		self.layer.cornerRadius = 10
		self.layer.masksToBounds = true
		self.segmentedMenu.selectedSegmentIndex = 0
        self.closeButton.onTap = { _ in
            self.hide()
        }
	}
	
	func show() {
		self.isHidden = false
		self.pollutantCircle.animate()
	}
	
	func hide() {
		self.isHidden = true
        segmentedMenu.selectedSegmentIndex = 0
		self.pollutantCircle.stopAnimation()
	}
	
	@IBAction func hide(_ sender: Any) {
		self.hide()
	}
    
    @IBAction func changeSegment(_ sender: Any) {
        let selectedIndex: Int = segmentedMenu.selectedSegmentIndex
		let selectedSection = SectionIdentifier.allCases[selectedIndex]
		self.contentTextView.attributedText = self.getAttributedText(section: selectedSection)
    }
    
	func update(pollutant: Pollutant) {
        self.selectedPollutant = pollutant.id
		self.pollutantTitle.text = PollutantView.config[pollutant.id]!.extendedTitle
		self.pollutantCircle.update(aqi: pollutant.aqi)
        self.contentTextView.attributedText = self.getAttributedText(section: .definition)
	}
	
    private func getAttributedText(section: SectionIdentifier) -> NSAttributedString {
        let fileName = self.selectedPollutant.rawValue + "-" + section.rawValue
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

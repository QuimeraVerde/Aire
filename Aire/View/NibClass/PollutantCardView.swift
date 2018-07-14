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
	case definition
	case causes
	case issues
}

class PollutantCardView: NibView {
	@IBOutlet weak var pollutantSummary: PollutantSummaryView!
	@IBOutlet weak var segmentedMenu: UISegmentedControl!
	@IBOutlet weak var contentTextView: UITextView!
	
	private var content: Dictionary<PollutantIdentifier, Dictionary<PollutantContentIdentifier, UITextView>>!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.layer.cornerRadius = 10
		self.layer.masksToBounds = true
		self.segmentedMenu.selectedSegmentIndex = 0
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
		self.updateTextView()
	}
	
	private func updateTextView() {
		self.contentTextView.attributedText = self.getAttributedText()
	}
	
	private func getAttributedText() -> NSAttributedString {
		if let url = Bundle.main.url(forResource: "pm10-definition", withExtension: "md") {
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

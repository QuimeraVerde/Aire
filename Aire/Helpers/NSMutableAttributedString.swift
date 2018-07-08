//
//  NSMutableAttributedString.swift
//  Aire
//
//  Created by Natalia García on 7/8/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UIKit

// An attributed string extension to achieve colors on text.
extension NSMutableAttributedString {
	func setColor(color: UIColor, forText stringValue: String) {
		let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
		self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
	}
	
	func bold(stringValue: String, fontSize: CGFloat) {
		let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
		self.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: range)
	}
}

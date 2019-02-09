//
//  UIUtility.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UIKit

struct UIUtility {
	static let color = Color()
	struct Color {
		var green: UIColor = UIColor()
		var yellow: UIColor = UIColor()
		var orange: UIColor = UIColor()
		var red: UIColor = UIColor()
		var purple: UIColor = UIColor()
		var crimson: UIColor = UIColor()
		
		init() {
			self.green = 	self.rgba(21, 152, 103, 1)
			self.yellow = 	self.rgba(254, 221, 71, 1)
			self.orange = 	self.rgba(253, 152, 64, 1)
			self.red = 		self.rgba(202, 10, 55, 1)
			self.purple = 	self.rgba(101, 18, 150, 1)
			self.crimson = 	self.rgba(124, 4, 37, 1)
		}
		
		private func rgba(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Int) -> UIColor {
			return UIColor(red: CGFloat(red)/255.0,
						   green: CGFloat(green)/255.0,
						   blue: CGFloat(blue)/255.0,
						   alpha: CGFloat(alpha))
		}
	}
}

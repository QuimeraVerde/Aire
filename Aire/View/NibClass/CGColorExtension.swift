//
//  UIColorExtension.swift
//  Aire
//
//  Created by Natalia García on 7/17/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

// code by https://stackoverflow.com/a/38435309

import UIKit

extension CGColor {
	
	func lighter(by percentage:CGFloat=30.0) -> CGColor? {
		return self.adjust(by: abs(percentage) )
	}
	
	func darker(by percentage:CGFloat=30.0) -> CGColor? {
		return self.adjust(by: -1 * abs(percentage) )
	}
	
	func adjust(by percentage:CGFloat=30.0) -> CGColor? {
		let uiColor = UIColor(cgColor: self)
		var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
		if(uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)){
			return UIColor(red: min(r + percentage/100, 1.0),
						   green: min(g + percentage/100, 1.0),
						   blue: min(b + percentage/100, 1.0),
						   alpha: a).cgColor
		}else{
			return nil
		}
	}
}

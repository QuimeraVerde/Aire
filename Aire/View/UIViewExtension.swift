//
//  UIViewExtension.swift
//  Aire
//
//  Created by Natalia García on 7/10/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		sharedInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		sharedInit()
	}
	
	override func prepareForInterfaceBuilder() {
		sharedInit()
	}
	
	override var bounds: CGRect {
		didSet {
			sharedInit()
		}
	}
	
	func sharedInit() {
		let width = self.frame.size.width
		self.layer.cornerRadius = width/2
		self.layer.bounds = CGRect(origin: self.bounds.origin, size: CGSize(width: width, height: width))
		self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: width, height: width))
	}
	
	@IBInspectable
	var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable
	var borderColor: UIColor? {
		get {
			if let color = layer.borderColor {
				return UIColor(cgColor: color)
			}
			return nil
		}
		set {
			if let color = newValue {
				layer.borderColor = color.cgColor
			} else {
				layer.borderColor = nil
			}
		}
	}
}


extension UIView {
	/** Loads instance from nib with the same name. */
	func loadNib() -> UIView {
		let bundle = Bundle(for: type(of: self))
		let nibName = type(of: self).description().components(separatedBy: ".").last!
		let nib = UINib(nibName: nibName, bundle: bundle)
		return nib.instantiate(withOwner: self, options: nil).first as! UIView
	}
}

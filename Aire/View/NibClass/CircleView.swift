//
//  CircleView.swift
//  Aire
//
//  Created by Natalia García on 7/13/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {
	var animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: .infinity, timingParameters: UICubicTimingParameters(animationCurve: .linear))
	
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
			setNeedsDisplay()
		}
	}
	
	private func sharedInit() {
		let width = self.frame.size.width
		self.layer.cornerRadius = width/2
		self.layer.bounds = CGRect(origin: self.bounds.origin,
								   size: CGSize(width: width, height: width))
		self.frame = CGRect(origin: self.frame.origin,
							size: CGSize(width: width, height: width))
	}
	
	private func animate() {
		self.animator = UIViewPropertyAnimator(duration: .infinity,
											   controlPoint1: CGPoint(x: 0.17, y: 0.67),
											   controlPoint2: CGPoint(x: 0.83, y: 0.67),
											   animations: {
			self.borderColor = self.borderColor?.adjust(by: 30)
			self.frame.applying(CGAffineTransform(scaleX: 2.0, y: 2.0))
			self.borderColor = self.borderColor?.adjust(by: -30)
			self.frame.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
		})
		self.animator.startAnimation()
	}
	
	@IBInspectable
	var animated: Bool = false {
		didSet {
			if(animated) {
				self.animate()
			}
		}
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
			return UIColor.white
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

//
//  BorderAnimation.swift
//  Aire
//
//  Created by Natalia García on 7/21/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import UIKit

struct BorderAnimation {
	private enum LayerProperty: String {
		case borderColor
		case scale = "transform.scale"
		case borderWidth
	}
	
	static func pulse(_ layer: CALayer) -> CAAnimationGroup {
		let darkColor = layer.borderColor?.darker(by: 40)
		let colorAnimation = loopAnimation(.borderColor,
							 initialValue: layer.borderColor!,
							 finalValue: darkColor!)
		
		let scaledDown = 0.9
		let scaleAnimation = loopAnimation(.scale,
							 initialValue: 1.0,
							 finalValue: scaledDown)
		
		let boldWidth = layer.borderWidth + 3
		let widthAnimation = loopAnimation(.borderWidth,
							 initialValue: layer.borderWidth,
							 finalValue: boldWidth)
		
		return self.groupAnimations(colorAnimation + scaleAnimation + widthAnimation,
									duration: 2.0)
	}
	
	private static func loopAnimation(_ layerProperty: LayerProperty,
									  initialValue: Any,
									  finalValue: Any) -> [CABasicAnimation] {
		// Initial animation
		var initialAnimation = CABasicAnimation(keyPath: layerProperty.rawValue)
		setAnimation(for: &initialAnimation,
					 from: initialValue,
					 to: finalValue)
		initialAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
		
		// Final animation will go back to initial value
		var finalAnimation = CABasicAnimation(keyPath: layerProperty.rawValue)
		setAnimation(for: &finalAnimation,
					 from: finalValue,
					 to: initialValue)
		finalAnimation.beginTime = initialAnimation.beginTime + initialAnimation.duration
		finalAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
		
		return [initialAnimation, finalAnimation]
	}
	
	private static func setAnimation(for animation: inout CABasicAnimation,
									 from fromValue: Any,
									 to toValue: Any) {
		animation.fromValue = fromValue
		animation.toValue = toValue
		animation.duration = 1.0
		animation.fillMode = CAMediaTimingFillMode.forwards
	}
	
	private static func groupAnimations(_ animations: [CABasicAnimation],
										duration: CFTimeInterval) -> CAAnimationGroup {
		let animation = CAAnimationGroup()
		animation.animations = animations
		animation.duration = duration
		animation.repeatCount = Float.infinity
		animation.isRemovedOnCompletion = false
		animation.fillMode = CAMediaTimingFillMode.forwards
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
		return animation
	}
}

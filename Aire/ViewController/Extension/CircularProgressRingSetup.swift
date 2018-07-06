//
//  CircularProgressRingSetup.swift
//  Aire
//
//  Created by Natalia García on 7/5/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import UICircularProgressRing

extension ViewController {
	func setupProgressRing() {
		//values
		ringView.minValue = 0
		ringView.maxValue = 300
		
		//colors
		ringView.ringStyle = .gradient
		ringView.gradientColors = [UIUtility.color.green,
								   UIUtility.color.yellow,
								   UIUtility.color.orange,
								   UIUtility.color.red,
								   UIUtility.color.crimson]
		ringView.gradientColorLocations = [0.0,
										   0.2,
										   0.4,
										   0.6,
										   0.8]
		ringView.gradientStartPosition = UICircularProgressRingGradientPosition.left
		ringView.gradientEndPosition = UICircularProgressRingGradientPosition.top
		
		//default value
		ringView.value = 0
	}
}

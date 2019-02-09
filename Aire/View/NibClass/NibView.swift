//
//  NibView.swift
//  Aire
//
//  Created by Natalia García on 7/10/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import UIKit
class NibView: UIView {
	var view: UIView!
	override init(frame: CGRect) {
		super.init(frame: frame)
		// Setup view from .xib file
		xibSetup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		// Setup view from .xib file
		xibSetup()
	}
}
private extension NibView {
	
	func xibSetup() {
		view = loadNib()
		// use bounds not frame or it'll be offset
		view.frame = bounds
		// Adding custom subview on top of our view
		addSubview(view)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
													  options: [],
													  metrics: nil,
													  views: ["childView": view]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
													  options: [],
													  metrics: nil,
													  views: ["childView": view]))
	}
}

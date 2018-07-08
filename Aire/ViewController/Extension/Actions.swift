//
//  Actions.swift
//  Aire
//
//  Created by Natalia García on 7/7/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation

extension ViewController {
	@IBAction func mapButtonAction(_ sender: Any){
		let pageViewController = self.parent as! PageViewController
		pageViewController.nextPage()
	}
}

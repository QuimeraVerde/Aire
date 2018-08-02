//
//  UIViewButton.swift
//  Aire
//
//  Created by Natalia García on 8/2/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class UIViewButton: UIView {
	
	private let disposeBag = DisposeBag()
	private var originalBackgroundColor: UIColor?
	private var originalTintColors: [UIColor] = []
	private var tapRecognizer: UITapGestureRecognizer?
	
	var onTap: (UIGestureRecognizer) -> Void {
		get {
			return self.onTap
		}
		set {
			self.setTapGesture(newValue)
			self.enabled = true
		}
	}
	
	var enabled: Bool {
		get {
			return self.enabled
		}
		set {
			if newValue {
				self.addTapGesture()
				self.alpha = 1.0
			}
			else {
				self.removeTapGesture()
				self.alpha = 0.5
			}
		}
	}
	
	private func addTapGesture() {
		if let tapRecognizer = self.tapRecognizer {
			self.addGestureRecognizer(tapRecognizer)
		}
	}
	
	private func removeTapGesture() {
		if let tapRecognizer = self.tapRecognizer {
			self.removeGestureRecognizer(tapRecognizer)
		}
	}
	
	private func setTapGesture(_ onTap: @escaping (UIGestureRecognizer) -> Void) {
		let tapRecognizer = UITapGestureRecognizer()
		tapRecognizer.rx.event
			.bind(onNext: { recognizer in
				onTap(recognizer)
			}).disposed(by: disposeBag)
		
		self.tapRecognizer = tapRecognizer
	}
}

//
//  PageViewController.swift
//  Aire
//
//  Created by Natalia García on 7/7/18.
//  Copyright © 2018 QuimeraVerde. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

class PageViewController : UIPageViewController {
	let locationManager = CLLocationManager()
	
	fileprivate lazy var pages: [UIViewController] = {
		return [
			self.getViewController(withIdentifier: "Home"),
			self.getViewController(withIdentifier: "Map")
		]
	}()
	
	fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
		return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.dataSource = self
		self.delegate   = self
		setupGeoLocation()
		if let firstVC = pages.first {
			setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
		}
	}
	
	func nextPage() {
		if let currentViewController = self.viewControllers?[0] {
			if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
				setViewControllers([nextPage], direction: .forward, animated: true, completion: nil)
			}
		}
	}
	
	func prevPage() {
		if let currentViewController = self.viewControllers?[0] {
			if let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) {
				setViewControllers([prevPage], direction: .reverse, animated: true, completion: nil)
			}
		}
	}
}

extension PageViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
		
		let previousIndex = viewControllerIndex - 1
		
		guard previousIndex >= 0          else { return nil }
		
		guard pages.count > previousIndex else { return nil }
		
		return pages[previousIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
		
		let nextIndex = viewControllerIndex + 1
		
		guard nextIndex < pages.count else { return nil }
		
		guard pages.count > nextIndex else { return nil }
		
		return pages[nextIndex]
	}
}

extension PageViewController: UIPageViewControllerDelegate { }

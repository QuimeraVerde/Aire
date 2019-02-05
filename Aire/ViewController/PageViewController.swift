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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.dataSource = self
		self.delegate   = self
		self.setupGeoLocation()
		if let firstVC = pages.first {
			setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
		}
		removeSwipeGesture()
	}
	
	fileprivate lazy var pages: [UIViewController] = {
		return [
			self.getViewController(withIdentifier: "Home"),
			self.getViewController(withIdentifier: "Map")
		]
	}()

    func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
	
	fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
		return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
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

extension PageViewController: CLLocationManagerDelegate {
	func setupGeoLocation() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestAlwaysAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
            let status = CLLocationManager.authorizationStatus()
            if status == .authorizedAlways || status == .authorizedWhenInUse  {
                locationManager.startUpdatingLocation()
            }
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //locationManager.requestLocation()
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			locationManager.requestLocation()
		}
		else {
            // Default coordinates MTY
			// UpdateSharedLocation(coordinate: CLLocationCoordinate2D(latitude: 25.6515697, longitude: -100.2917287))
            // Ask for location input
            let alert = UIAlertController(title: "Aire necesita tu ubicación", message: "También puedes escoger cualquier lugar del mundo usando nuestro mapa", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Ir a preferencias", style: .default) { (_) -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alert.addAction(settingsAction)
            alert.addAction(UIAlertAction(title: "Seguir sin mi ubicación", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if !Location.sharedCoordinate.isReady {
			if let location = locations.first {
				locationManager.stopUpdatingLocation()
				updateSharedLocation(coordinate: location.coordinate)
			}
		}
	}
	
	func updateSharedLocation(coordinate: CLLocationCoordinate2D) {
		Location.sharedCoordinate.update(coordinate: coordinate)
		NetworkManager.isReachable(completed: { _ in
			Location.sharedAddress.update()
		})
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error:: \(error)")
	}
}

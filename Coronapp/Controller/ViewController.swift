//
//  ViewController.swift
//  Coronapp
//
//  Created by Robert Pelka on 07/10/2020.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let coronaManager = CoronaManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            CLGeocoder().reverseGeocodeLocation(location) { (placeMark, error) in
                if error != nil {
                    print(error!)
                }
                else {
                    if let place = placeMark?[0]{
                        let countryCode = place.isoCountryCode!
                        self.coronaManager.fetchData(for: countryCode)
                    }
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

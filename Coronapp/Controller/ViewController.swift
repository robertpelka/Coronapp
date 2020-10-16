//
//  ViewController.swift
//  Coronapp
//
//  Created by Robert Pelka on 07/10/2020.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var globalStatistics: GlobalModel?
    var statistics: CoronaModel?
    let locationManager = CLLocationManager()
    var coronaManager = CoronaManager()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var globalButton: UIButton!
    @IBOutlet weak var countryTitle: UILabel!
    @IBOutlet weak var newCases: UILabel!
    @IBOutlet weak var newDeaths: UILabel!
    @IBOutlet weak var newRecovered: UILabel!
    @IBOutlet weak var totalCases: UILabel!
    @IBOutlet weak var totalDeaths: UILabel!
    @IBOutlet weak var totalRecovered: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        globalButton.layer.cornerRadius = globalButton.frame.size.height/2
        globalButton.isHidden = true
    
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        coronaManager.delegate = self
        coronaManager.fetchData()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if(globalButton.currentTitle! == "Show global") {
            if let globalStats = globalStatistics {
                setGlobalStats(stats: globalStats)
            }
        }
        else if(globalButton.currentTitle! == "Show local") {
            if let stats = statistics {
                setStats(stats: stats)
            }
        }
    }
    
    func setGlobalStats(stats: GlobalModel) {
        self.globalButton.setTitle("Show local", for: .normal)
        self.countryTitle.text = "for the world"
        self.newCases.text = String(stats.NewConfirmed)
        self.newDeaths.text = String(stats.NewDeaths)
        self.newRecovered.text = String(stats.NewRecovered)
        self.totalCases.text = String(stats.TotalConfirmed)
        self.totalDeaths.text = String(stats.TotalDeaths)
        self.totalRecovered.text = String(stats.TotalRecovered)
    }
    
    func setStats(stats: CoronaModel) {
        globalButton.setTitle("Show global", for: .normal)
        self.countryTitle.text = "for " + stats.Country
        self.newCases.text = String(stats.NewConfirmed)
        self.newDeaths.text = String(stats.NewDeaths)
        self.newRecovered.text = String(stats.NewRecovered)
        self.totalCases.text = String(stats.TotalConfirmed)
        self.totalDeaths.text = String(stats.TotalDeaths)
        self.totalRecovered.text = String(stats.TotalRecovered)
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

//MARK: - CoronaManagerDelegate

extension ViewController: CoronaManagerDelegate {
    func didUpdateGlobalStats(coronaManager: CoronaManager, stats: GlobalModel) {
        DispatchQueue.main.async {
            self.globalStatistics = stats
            self.setGlobalStats(stats: stats)
        }
    }
    
    func didUpdateStats(coronaManager: CoronaManager, stats: CoronaModel) {
        DispatchQueue.main.async {
            self.globalButton.isHidden = false
            self.statistics = stats
            self.setStats(stats: stats)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let country = searchBar.text {
            self.coronaManager.fetchDataFullName(for: country.capitalized)
        }
    }
}

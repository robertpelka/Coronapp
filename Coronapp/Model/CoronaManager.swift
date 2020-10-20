//
//  CoronaManager.swift
//  Coronapp
//
//  Created by Robert Pelka on 07/10/2020.
//

import Foundation

protocol CoronaManagerDelegate {
    func didUpdateGlobalStats(coronaManager: CoronaManager, stats: GlobalModel)
    func didUpdateStats(coronaManager: CoronaManager, stats: CoronaModel)
    func didFailWithError(error: Error)
    func countryNotFound(country: String)
}

struct CoronaManager {
    let url = URL(string: "https://api.covid19api.com/summary")
    
    var delegate: CoronaManagerDelegate?
    
    func fetchData() {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                if let data = self.parseJSON(coronaData: safeData) {
                    let statisticsGlobal = GlobalModel(NewConfirmed: data.Global.NewConfirmed, TotalConfirmed: data.Global.TotalConfirmed, NewDeaths: data.Global.NewDeaths, TotalDeaths: data.Global.TotalDeaths, NewRecovered: data.Global.NewRecovered, TotalRecovered: data.Global.TotalRecovered)
                    self.delegate?.didUpdateGlobalStats(coronaManager: self, stats: statisticsGlobal)
                }
            }
        }
        task.resume()
    }
    
    func fetchData(for countryCode: String) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                if let data = self.parseJSON(coronaData: safeData) {
                    if let found = data.Countries.first(where: {$0.CountryCode == countryCode}) {
                        let statistics = CoronaModel(Country: found.Country, CountryCode: found.CountryCode, NewConfirmed: found.NewConfirmed, TotalConfirmed: found.TotalConfirmed, NewDeaths: found.NewDeaths, TotalDeaths: found.TotalDeaths, NewRecovered: found.NewRecovered, TotalRecovered: found.TotalRecovered, Date: found.Date)
                        self.delegate?.didUpdateStats(coronaManager: self, stats: statistics)
                    } else {
                        self.delegate?.didFailWithError(error: "Error - countryCode not found" as! Error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetchDataFullName(for country: String) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                if let data = self.parseJSON(coronaData: safeData) {
                    if let found = data.Countries.first(where: {$0.CountryCode.lowercased() == country.lowercased()}) {
                        let statistics = CoronaModel(Country: found.Country, CountryCode: found.CountryCode, NewConfirmed: found.NewConfirmed, TotalConfirmed: found.TotalConfirmed, NewDeaths: found.NewDeaths, TotalDeaths: found.TotalDeaths, NewRecovered: found.NewRecovered, TotalRecovered: found.TotalRecovered, Date: found.Date)
                        self.delegate?.didUpdateStats(coronaManager: self, stats: statistics)
                    } else if let found = data.Countries.first(where: {$0.Country.lowercased().hasPrefix(country.lowercased())}) {
                        let statistics = CoronaModel(Country: found.Country, CountryCode: found.CountryCode, NewConfirmed: found.NewConfirmed, TotalConfirmed: found.TotalConfirmed, NewDeaths: found.NewDeaths, TotalDeaths: found.TotalDeaths, NewRecovered: found.NewRecovered, TotalRecovered: found.TotalRecovered, Date: found.Date)
                        self.delegate?.didUpdateStats(coronaManager: self, stats: statistics)
                    } else {
                        self.delegate?.countryNotFound(country: country)
                    }
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(coronaData: Data) -> CoronaData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoronaData.self, from: coronaData)
            return decodedData
        }
        catch let jsonError as NSError {
            self.delegate?.didFailWithError(error: jsonError)
            return nil
        }
    }
}

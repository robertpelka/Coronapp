//
//  CoronaManager.swift
//  Coronapp
//
//  Created by Robert Pelka on 07/10/2020.
//

import Foundation

struct CoronaManager {
    let url = URL(string: "https://api.covid19api.com/summary")
    
    func fetchData(for countryCode: String) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            if let safeData = data {
                if let data = self.parseJSON(coronaData: safeData) {
                    if let found = data.Countries.first(where: {$0.CountryCode == countryCode}) {
                        let statistics = CoronaModel(Country: found.Country, CountryCode: found.CountryCode, NewConfirmed: found.NewConfirmed, TotalConfirmed: found.NewConfirmed, NewDeaths: found.NewDeaths, TotalDeaths: found.TotalDeaths, Date: found.Date, NewConfirmedGlobal: data.Global.NewConfirmed, TotalConfirmedGlobal: data.Global.TotalConfirmed, NewDeathsGlobal: data.Global.NewDeaths, TotalDeathsGlobal: data.Global.TotalDeaths)
                    } else {
                        print("Error - countryCode not found")
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
            print(jsonError)
            return nil
        }
    }
}

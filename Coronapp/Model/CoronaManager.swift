//
//  CoronaManager.swift
//  Coronapp
//
//  Created by Robert Pelka on 07/10/2020.
//

import Foundation

struct CoronaManager {
    let url = URL(string: "https://api.covid19api.com/summary")
    
    func fetchData() {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("error1")
                return
            }
            if let safeData = data {
                if let data = self.parseJSON(coronaData: safeData) {
                    
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

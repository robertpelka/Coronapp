//
//  CoronaData.swift
//  Coronapp
//
//  Created by Robert Pelka on 10/10/2020.
//

import Foundation

struct CoronaData: Decodable {
    let Global: Global
    let Countries: [Countries]
}

struct Global: Decodable {
    let NewConfirmed: Int
    let TotalConfirmed: Int
    let NewDeaths: Int
    let TotalDeaths: Int
}

struct Countries: Decodable {
    let CountryCode: String
    let NewConfirmed: Int
    let TotalConfirmed: Int
    let NewDeaths: Int
    let TotalDeaths: Int
    let Date: String
}

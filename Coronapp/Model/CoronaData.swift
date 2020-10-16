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
    let NewRecovered: Int
    let TotalRecovered: Int
}

struct Countries: Decodable {
    let Country: String
    let CountryCode: String
    let NewConfirmed: Int
    let TotalConfirmed: Int
    let NewDeaths: Int
    let TotalDeaths: Int
    let NewRecovered: Int
    let TotalRecovered: Int
    let Date: String
}

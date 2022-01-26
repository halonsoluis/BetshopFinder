//
//  BetshopModel.swift
//  betshops
//
//  Created by Hugo Alonso on 26/01/2022.
//

import Foundation

struct BetshopModel {
    let id: Int64

    let name: String
    let address: String
    let topLevelAddress: String

    let location: (lat: Double, lng: Double)

    //Harcoded Data not provided by the API
    static let workingHours = (opening: "08:00", closing:"16:00")
}

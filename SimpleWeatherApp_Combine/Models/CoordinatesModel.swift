//
//  CoordinatesModel.swift
//  SimpleWeatherApp_Combine
//
//  Created by Lewis on 26.02.2023.
//

import Foundation

struct CoordinatesModel: Decodable {
    let name: String?
    let lat: Double?
    let lon: Double?
    let country: String?
    
    static var placeholder: CoordinatesModel {
        return CoordinatesModel(name: nil, lat: nil, lon: nil, country: nil)
    }
}

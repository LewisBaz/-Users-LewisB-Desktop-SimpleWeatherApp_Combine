//
//  WeatherModel.swift
//  SimpleWeatherApp_Combine
//
//  Created by Lewis on 26.02.2023.
//

import Foundation

struct WeatherModel: Decodable {
    let main: CurrentWeather
    
    static var placeholder: WeatherModel {
        return WeatherModel(main: CurrentWeather(temp: nil))
    }
}

struct CurrentWeather: Decodable {
    let temp: Double?
}

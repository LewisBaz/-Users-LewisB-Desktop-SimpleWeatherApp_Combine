//
//  WeatherNetworkManager.swift
//  SimpleWeatherApp_Combine
//
//  Created by Lewis on 26.02.2023.
//

import Foundation
import Combine

final class WeatherNetworkManager {
    
    private lazy var apiKey = "c69a205230228ec4ab6d8e282a511235"
    private let coordinatesAPI = "http://api.openweathermap.org/geo/1.0/direct"
    private let weatherAPI = "https://api.openweathermap.org/data/2.5/weather"
    
    private let decoder = JSONDecoder()
    
    var cancellable: AnyCancellable?
      
    func getCityCoordinates(cityName: String) -> AnyPublisher<CoordinatesModel?, Error> {
        guard let url = URL(string: coordinatesAPI) else {
            return Fail(error: NSError(domain: "Invalid URL", code: Constants.ErrorCodes.invalidURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.url?.append(queryItems: [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "appid", value: apiKey)
        ])
        
        guard let requestURL = request.url else {
            return Fail(error: NSError(domain: "Invalid URL", code: Constants.ErrorCodes.invalidURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: requestURL)
            .map({ $0.data })
            .decode(type: [CoordinatesModel].self, decoder: decoder)
            .map { $0.first }
            .eraseToAnyPublisher()
    }
    
    func getCityWeather(lat: String?, lon: String?) -> AnyPublisher<WeatherModel, Error> {
        guard let url = URL(string: weatherAPI) else {
            return Fail(error: NSError(domain: "Invalid URL", code: Constants.ErrorCodes.invalidURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.url?.append(queryItems: [
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "lon", value: lon),
            URLQueryItem(name: "appid", value: apiKey)
        ])
        
        guard let requestURL = request.url else {
            return Fail(error: NSError(domain: "Invalid URL", code: Constants.ErrorCodes.invalidURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: requestURL)
            .map({ $0.data })
            .decode(type: WeatherModel.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

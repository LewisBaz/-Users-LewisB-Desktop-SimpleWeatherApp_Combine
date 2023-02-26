//
//  MainViewController.swift
//  SimpleWeatherApp_Combine
//
//  Created by Lewis on 26.02.2023.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var enterCityTextField: UITextField!
    @IBOutlet weak var tempWeather: UILabel!
    
    // MARK: - Managers
    
    private let networkManager = WeatherNetworkManager()
    
    private var getCityCoordinatesCancellable: AnyCancellable?
    private var getCityWeatherCancellable: AnyCancellable?
    private var textFieldCancellable: AnyCancellable?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }
}

// MARK: - Private Methods

private extension MainViewController {
    
    func getCityCoordinates(city: String) {
        getCityCoordinatesCancellable = networkManager.getCityCoordinates(cityName: city)
            .catch({ _ in Just(CoordinatesModel.placeholder) })
            .sink(receiveValue: { coordinates in
                self.getTempWithCoordinates(lat: coordinates?.lat, lon: coordinates?.lon)
            })
    }
    
    func getTempWithCoordinates(lat: Double?, lon: Double?) {
        guard let lat = lat,
              let lon = lon else { return }
        getCityWeatherCancellable = networkManager.getCityWeather(lat: .init(lat), lon: .init(lon))
            .catch({ _ in Just(WeatherModel.placeholder) })
            .map { String(format: "%.1f", ($0.main.temp ?? 0.0) - 273.15) + " °C" }
            .assign(to: \.text, on: tempWeather)
    }
    
    func setupTextField() {
        let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: enterCityTextField)
        
        textFieldCancellable = publisher
            .compactMap({ ($0.object as! UITextField).text })
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] city in
                self?.getCityCoordinates(city: city)
            }
    }
}

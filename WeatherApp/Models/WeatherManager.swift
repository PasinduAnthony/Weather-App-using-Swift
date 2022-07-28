//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-15.
//

import Foundation

enum WeatherUnit: String, Equatable {
    case metric = "metric"
    case imperial = "imperial"
}

class WeatherManager: ObservableObject {
    
    let currentWeatherBaseURL: String = "https://api.openweathermap.org/data/2.5/weather?appid=\(API.key)"
    let oneCallBaseURL: String = "https://api.openweathermap.org/data/2.5/onecall?exclude=hourly,minutely&appid=\(API.key)"
    
    // Lat and lon of Kandy
    private let lat = 7.291418
    private let lon = 80.636696
    
    @Published var weather: WeatherModel?
    private var unit: WeatherUnit = .metric
    
    func fetchForCurrentLocation(lat: Double,lon: Double,unit: WeatherUnit) async {
        self.unit = unit
        let url = "\(currentWeatherBaseURL)&lat=\(lat)&lon=\(lon)&units=\(unit)"
        print(url)
        
        await requestWeather(url: url)
    }
    
    func fetchForCurrentLocation(place: String,unit: WeatherUnit) async {
        self.unit = unit
        let url = "\(currentWeatherBaseURL)&q=\(place)&units=\(unit)"
        print(url)
        
        await requestWeather(url: url)
    }
    
    func fetchForCity(string: String, unit: WeatherUnit) async {
        self.unit = unit
        let url = "\(currentWeatherBaseURL)&q=\(string)&units=\(unit.rawValue)"
        print(url)

        await requestWeather(url: url)
    }
    
    func getFiveDayForecast(unit: WeatherUnit) {
        let url = "\(oneCallBaseURL)&lat=\(lat)&lon=\(lon)&units=\(unit.rawValue)"
    }
    
    func requestOneCallForecast(url: String) async {
        guard let url = URL(string: url) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url) // Defining a session using a URL for requests
            let weather =  try JSONDecoder().decode(WeatherData.self, from: data) // Converting a JSON response into Swift Objects
            DispatchQueue.main.async {
                self.weather = WeatherModel(id: weather.weather.first?.id ?? 0,
                                            name: weather.name,
                                            lon: weather.coord.lon,
                                            lat: weather.coord.lat,
                                            timezone: weather.timezone,
                                            temperature: weather.main.temp,
                                            main: weather.weather.first?.main ?? "",
                                            description: weather.weather.first?.description ?? "",
                                            humidity: weather.main.humidity,
                                            pressure: weather.main.pressure,
                                            windSpeed: weather.wind.speed,
                                            direction: weather.wind.deg,
                                            cloudPercentage: weather.clouds.all,
                                            unit: self.unit)
            }
            print(weather)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func requestWeather(url: String) async {
        guard let url = URL(string: url) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url) // Defining a session using a URL for requests
            let weather =  try JSONDecoder().decode(WeatherData.self, from: data) // Converting a JSON response into Swift Objects
            DispatchQueue.main.async {
                self.weather = WeatherModel(id: weather.weather.first?.id ?? 0,
                                            name: weather.name,
                                            lon: weather.coord.lon,
                                            lat: weather.coord.lat,
                                            timezone: weather.timezone,
                                            temperature: weather.main.temp,
                                            main: weather.weather.first?.main ?? "",
                                            description: weather.weather.first?.description ?? "",
                                            humidity: weather.main.humidity,
                                            pressure: weather.main.pressure,
                                            windSpeed: weather.wind.speed,
                                            direction: weather.wind.deg,
                                            cloudPercentage: weather.clouds.all,
                                            unit: self.unit)
            }
            print(weather)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

//
//  OneCallWeatherManager.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-16.
//

import Foundation
import SwiftUI

class OneCallWeatherManager: ObservableObject {
    
    let oneCallBaseURL: String = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&appid=\(API.key)"
    
    // Lat and lon of Kandy
    private let lat = 7.291418
    private let lon = 80.636696
    
    @Published var weather: OCWeatherModel?
    @StateObject private var viewModel = ContentViewModel()
    private var unit: WeatherUnit = .metric
    
//    func getFiveDayForecast(unit: WeatherUnit) async {
//        self.unit = unit
//        let url = "\(oneCallBaseURL)&lat=\(lat)&lon=\(lon)&units=\(unit.rawValue)"
//        await requestForecast(url: url)
//    }
    
    func getFiveDayForecast(unit: WeatherUnit, lat: Double, lon: Double) async {
        self.unit = unit
        let url = "\(oneCallBaseURL)&lat=\(lat)&lon=\(lon)&units=\(unit.rawValue)"
        print(url)
        await requestForecast(url: url)
    }
    
    func requestForecast(url: String) async {
        guard let url = URL(string: url) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url) // Defining a session using a URL for requests
            let weather =  try JSONDecoder().decode(OneCallWeather.self, from: data) // Converting a JSON response into Swift Objects
            DispatchQueue.main.async {
                let forecasts = weather.daily.map { daily in
                    OCWeatherDisplay(dt: daily.dt.unixToDate()!,
                                     temp: self.unit == .metric ? "\(daily.temp.day.roundDouble())°C" : "\(daily.temp.day.roundDouble())°F",
                                     minTemp : self.unit == .metric ? "\(daily.temp.min)" : "\(daily.temp.min)",
                                     maxTemp : self.unit == .metric ? "\(daily.temp.max)" : "\(daily.temp.max)",
                                     pressure: daily.pressure,
                                     humidity: daily.humidity,
                                     clouds: daily.clouds,
                                     wind_speed: self.unit == .metric ? "\(daily.wind_speed) m/s" : "\(daily.wind_speed) mi/h",
                                     weather: daily.weather.first!,
                                     icon: self.getIcon(id: daily.weather.first!.main))
                }
                
                let first = weather.hourly.first!
                let current = OCWeatherDisplayHourly(dt: first.dt.unixToDate(date: .complete, time: .shortened)!,
                                                     temp: self.unit == .metric ? "\(first.temp.roundDouble())°C" : "\(first.temp.roundDouble())°F",
                                                     weather: first.weather.first!,
                                                     icon: self.getIcon(id: first.weather.first!.main),
                                                     hour: first.dt.unixToDate()!.get(.hour))
                var hourly = weather.hourly.map { hourly in
                    OCWeatherDisplayHourly(dt: hourly.dt.unixToDate(date: .omitted, time: .shortened)!,
                                           temp: self.unit == .metric ? "\(hourly.temp.roundDouble())°C" : "\(hourly.temp.roundDouble())°F",
                                           weather: hourly.weather.first!,
                                           icon: self.getIcon(id: hourly.weather.first!.main),
                                           hour: hourly.dt.unixToDate()!.get(.hour))
                }
                
                hourly = hourly.filter({ item in
                    return item.hour % 3 == 0
                })
                
                self.weather = OCWeatherModel(forecast: forecasts,
                                              hourlyForecasts: hourly,
                                              current: current)
            }
            print("OCWeather: ",weather)
        } catch {
            print("OCError: ",error.localizedDescription)
        }
    }
    
    func getIcon(id: Int) -> String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    func getIcon(id: String) -> String {
        switch id {
        case "Thunderstorm":
            return "cloud.bolt.rain"
        case "Drizzle":
            return "cloud.drizzle"
        case "Rain":
            return "cloud.rain"
        case "Snow":
            return "snowflake"
        case "Mist":
            return "cloud.fog"
        case "Smoke":
            return "smoke"
        case "Haze":
            return "tropicalstorm"
        case "Dust":
            return "tropicalstorm"
        case "Fog":
            return "cloud.fog"
        case "Sand":
            return "tropicalstorm"
        case "Ash":
            return "tropicalstorm"
        case "Squall":
            return "wind"
        case "Tornado":
            return "tornado"
        case "Clear":
            return "sun.max"
        case "Clouds":
            return "cloud"
        default:
            return "cloud"
        }
    }
    
}


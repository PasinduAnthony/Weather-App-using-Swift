//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-16.
//

import Foundation
import SwiftUI

struct WeatherModel {
    let id: Int
    let name: String
    let lon: Double
    let lat: Double
    let timezone: Int
    let temperature: Double
    let main: String
    let description: String
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let direction: Int
    let cloudPercentage: Int
    let unit: WeatherUnit
    
    var tempString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionIcon: String {
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
    
    var getWindDir: String{
        switch direction{
        
        case 0:
                return "N"
        case 0...45:
                return "NE"
        case 45...90:
                return "E"
        case 90...135:
                return "SE"
        case 135...180:
                return "S"
        case 180...226:
                return "SW"
        case 226...270:
                return "W"
        case 270...315:
                return "NW"
        default:
            return "--"
        
        }
    }
    
    func getVideo(id: String) -> String {
        switch id {
        case "Thunderstorm":
            return "Lightning"
        case "Drizzle":
            return "Rain"
        case "Rain":
            return "Rain"
        case "Snow":
            return "Rain"
        case "Mist":
            return "Rain"
        case "Smoke":
            return "Rain"
        case "Haze":
            return "Lightning"
        case "Dust":
            return "Rain"
        case "Fog":
            return "Rain"
        case "Sand":
            return "Cloud"
        case "Ash":
            return "Cloud"
        case "Squall":
            return "Rain"
        case "Tornado":
            return "Cloud"
        case "Clear":
            return "Cloud"
        case "Clouds":
            return "Rain"
        default:
            return "Cloud"
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
    
    var detailedData: [WeatherDetailData] {
        return [
            .init(title: "Temperature", icon: "thermometer", color: Color.red, value: tempString, unit: self.unit == .metric ? "°C" : "°F"),
            .init(title: "Humidity", icon: "drop.fill", color: Color.blue, value: "\(humidity)", unit: "%"),
            .init(title: "Pressure", icon: "digitalcrown.horizontal.press.fill", color: Color.green, value: "\(pressure)", unit: "hPa"),
            .init(title: "Wind speed", icon: "wind", color: Color.orange, value: "\(windSpeed)", unit: self.unit == .metric ? "m/s" : "mi/h"),
            .init(title: "Wind direction", icon: "arrow.up.left.circle", color: Color.yellow, value: "\(direction)"),
            .init(title: "Cloud Percentage", icon: "icloud", color: Color.cyan, value: "\(cloudPercentage)"),
        ]
    }
}

struct WeatherDetailData: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let value: String
    var unit: String = ""
}


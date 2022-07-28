//
//  OneCallWeather.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-16.
//

import Foundation

struct OneCallWeather: Decodable {
    let current: Current
    let daily: [OCDaily]
    let hourly: [OCHourly]
}

struct Current: Decodable {
    let dt: Int
    let temp: Double
    let pressure: Int
    let humidity: Int
    let clouds: Int
    let wind_speed: Double
    let weather: [Weather]
}

struct OCDaily: Decodable {
    let dt: Int
    let temp: Temperature
    let pressure: Int
    let humidity: Int
    let clouds: Int
    let wind_speed: Double
    let weather: [Weather]
}

struct Temperature: Decodable {
    let day: Double
    let min: Double
    let max: Double
}

struct OCHourly: Decodable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}


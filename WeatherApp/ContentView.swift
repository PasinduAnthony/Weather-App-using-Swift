//
//  ContentView.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-14.
//

import SwiftUI
import AVFAudio
// Define your Environment Key
struct RectangleSizeKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

// Define your Environment Values and its variable name
extension EnvironmentValues {
    var rectangleSize: Bool {
        get {
            self[RectangleSizeKey.self]
        }
        set {
            self[RectangleSizeKey.self] = newValue
        }
    }
}

// Define your Environment Key
struct Lat: EnvironmentKey {
    static let defaultValue: Double = 0.0
}

// Define your Environment Values and its variable name
extension EnvironmentValues {
    var lat: Double {
        get {
            self[Lat.self]
        }
        set {
            self[Lat.self] = newValue
        }
    }
}

// Define your Environment Key
struct Lon: EnvironmentKey {
    static let defaultValue: Double = 0.0
}

// Define your Environment Values and its variable name
extension EnvironmentValues {
    var lon: Double {
        get {
            self[Lon.self]
        }
        set {
            self[Lon.self] = newValue
        }
    }
}

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.isLive, order: .reverse)]) var locationCD: FetchedResults<Locations>
    
    var body: some View {
        if locationCD.isEmpty{
            if let location = locationManager.location {
                TabView {
                    SearchView(livelat: location.latitude, liveLon: location.longitude)
                        .environmentObject(locationManager)
                        .tabItem {
                            Label("Live location", systemImage: "location")
                        }
                    HomeScreen()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    ForecastView()
                        .tabItem {
                            Label("Forecast", systemImage: "goforward")
                        }
                    IntervalWeatherView()
                        .tabItem {
                            Label("Intervals", systemImage: "deskclock")
                        }
                }
            }else{
                SearchView(livelat: 0.0, liveLon: 0.0)
                    .environmentObject(locationManager)
            }
            
        }else{
            TabView {
                if let location = locationManager.location {
                    SearchView(livelat: location.latitude, liveLon: location.longitude)
                        .environmentObject(locationManager)
                        .tabItem {
                            Label("Live location", systemImage: "location")
                        }
                    HomeScreen()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    ForecastView()
                        .tabItem {
                            Label("Forecast", systemImage: "goforward")
                        }
                    IntervalWeatherView()
                        .tabItem {
                            Label("Intervals", systemImage: "deskclock")
                        }
                }else{
                    HomeScreen()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    SearchView(livelat: 0.0, liveLon: 0.0)
                        .environmentObject(locationManager)
                        .tabItem {
                            Label("Current", systemImage: "magnifyingglass")
                        }
                    ForecastView()
                        .tabItem {
                            Label("Forecast", systemImage: "goforward")
                        }
                    IntervalWeatherView()
                        .tabItem {
                            Label("Intervals", systemImage: "deskclock")
                        }
                }
                
               
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

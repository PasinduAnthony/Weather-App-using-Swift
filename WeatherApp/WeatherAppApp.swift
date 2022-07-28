//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-14.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

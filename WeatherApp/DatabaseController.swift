//
//  DatabaseController.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-16.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "BackgroundData") // Loads/Caches the container
    
    init() {
        container.loadPersistentStores { description, error in // Actually loading it into RAM
            if let error = error {
                print("Core Data loading error: \(error.localizedDescription)")
            }
        }
    }
}

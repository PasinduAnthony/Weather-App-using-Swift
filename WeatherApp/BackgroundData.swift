//
//  BackgroundData.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-16.
//

import Foundation

class BackgroundData: Identifiable, Codable{
    var vidName = "Cloud"
}

class BackgroundDatas: ObservableObject{
    @Published  var data : [BackgroundData]
    
    init(){
        self.data = []
    }
}

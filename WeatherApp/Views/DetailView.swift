//
//  DetailView.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-14.
//

import SwiftUI

struct DetailView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.isLive, order: .reverse)]) var locationCD: FetchedResults<Locations>
    @State private var unit: WeatherUnit = .metric
    @StateObject private var manager = OneCallWeatherManager()
    @State private var temp = 0
    
    var locName = ""  //parameters
    var vidName = ""
    
    @State private var lat : Double = 0.0
    @State private var lon : Double = 0.0
    @State private var navBarDisplay = false
    
    var body: some View {
        NavigationView{
            ZStack{
                VideoBackgroundView(videoName: vidName.isEqual("") ? "Cloud" : vidName)
                    .onAppear{
                        if locName == ""{
                            navBarDisplay = true
                        }else{
                            navBarDisplay = false
                        }
                    }
                Spacer()
                ScrollView(.vertical) {
                    VStack(){
                        if let data = manager.weather {
                            VStack {
                                //Spacer()
                                VStack(alignment: .leading, spacing: 20) {
                                    HStack{
                                        Text("Hourly Forecast")
                                            .bold()
                                            .padding(.bottom)
                                    }
                                    if let current = data.current {
                                        Text(locName ?? "--")
                                            .bold().font(.title)
                                        Text("Today, \(Date().formatted(.dateTime.month().hour().minute()))")
                                            .fontWeight(.light)
                                        VStack{
                                            HStack{
                                                VStack(spacing: 20){
                                                    Image(systemName: current.icon)
                                                        .font(.system(size: 40))
                                                    Text(current.weather.description ?? "--") //Weather condition
                                                }
                                                .frame(width: 150, alignment: .leading)
                                                
                                                Spacer()
                                                Text((current.temp ?? "--")) //feels like
                                                    .font(.system(size: 70))
                                                    .fontWeight(.bold)
                                            }
                                            Spacer()
                                        }.frame(maxWidth: .infinity)
                                    }
                                    ScrollView(.horizontal) {
                                        
                                        
                                        HStack(spacing: 10){
                                            ForEach(data.hourlyForecasts) { item in
                                                VStack{
                                                    
                                                    Text(item.dt)
                                                    Image(systemName: item.icon)
                                                        .font(.title)
                                                        .frame(width: 20, height: 20)
                                                        .padding()
                                                        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                                                        .cornerRadius(50)
                                                    Text(item.weather.description ?? "--")
                                                        .font(.caption)
                                                    Text("\(item.temp)")
                                                        .bold()
                                                        .font(.title)
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .padding(.bottom, 20)
                                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                                .background(Color.white.opacity(0.75))
                                .cornerRadius(20)
                            }
                            Spacer()
                        }else {
                            Spacer()
                        }
                        
                    }.onAppear {
                        Task {
                            await manager.getFiveDayForecast(unit: self.unit,lat: lat, lon: lon )
                        }
                    }
                    
                    VStack(){
                        if let data = manager.weather {
                            VStack {
                                //Spacer()
                                VStack(alignment: .leading, spacing: 20) {
                                    HStack{
                                        Text("Daily Forecast")
                                            .bold()
                                            .padding(.bottom)
                                    }
                                    
                                    if let data = manager.weather?.forecast {
                                        
                                        ForEach (0..<6) { index in
                                            let item = data[index]
                                            Section("\(item.dt)") {
                                                Divider().background(Color.gray)
                                                HStack{
                                                    VStack{
                                                        Image(systemName: item.icon)
                                                            .font(.title)
                                                            .frame(width: 20, height: 20)
                                                            .padding()
                                                            .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                                                            .cornerRadius(50)
                                                        Text(item.weather.description ?? "--")
                                                            .font(.caption)
                                                    }
                                                    VStack {
                                                        HStack{
                                                            Image(systemName: "cloud.fill")
                                                                .foregroundColor(.gray)
                                                                .frame(alignment: .leading)
                                                            Text("\(item.clouds)%      ")
                                                        }
                                                        HStack{
                                                            Image(systemName: "drop")
                                                                .foregroundColor(.blue)
                                                            Text("\(item.wind_speed)")
                                                        }
                                                    }
                                                    Text("Humidity: \(item.humidity)%")
                                                    Text("\(item.temp)")
                                                        .bold()
                                                        .font(.title)
                                                }
                                                Divider().background(Color.gray)
                                            }
                                        }.onChange(of: unit) { _ in
                                            Task {
                                                await manager.getFiveDayForecast(unit: self.unit,lat: lat, lon: lon )
                                            }
                                        }
                                    }
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .padding(.bottom, 20)
                                .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                                .background(Color.white.opacity(0.85))
                                .cornerRadius(20)
                            }
                            Spacer()
                        }else {
                            Spacer()
                        }
                        
                    }.onAppear {
                        for location in locationCD{
                            if(location.location == locName){
                                lat = location.lat
                                lon = location.lon
                                Task {
                                    await manager.getFiveDayForecast(unit: self.unit,lat: lat, lon: lon )
                                }
                            }
                        }
                    }
                    
                }
            }
        }.navigationBarHidden(navBarDisplay)
            .navigationBarTitle("Detail View")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}

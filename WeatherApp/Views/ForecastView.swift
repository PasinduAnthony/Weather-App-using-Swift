//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-22.
//

import SwiftUI

struct ForecastView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.isLive, order: .reverse)]) var locationCD: FetchedResults<Locations>
    @State private var unit: WeatherUnit = .metric
    @StateObject private var manager = OneCallWeatherManager()
    @State private var temp = 0
    
    var locName = ""  //paramater
    
    
    @State private var min : Double = 0.00  //local vars
    @State private var max : Double = 0.00
    @State private var currentMin : Double = 0.00
    @State private var currentMax : Double = 0.00
    @State var count = 0
    @State var reachEnd = false
    @State var unitDisplay = "C"
    @State var windSpeed = ""
    @State var cloud = ""
    @State var humidity = ""
    
    @State var width : CGFloat = 0 //screen size vars
    @State var compWidth : CGFloat = 0
    @State var compWidth2 : CGFloat = 0
    
    var body: some View {
        NavigationView{
            ZStack{
                VideoBackgroundView(videoName: locationCD[0].vidName ?? "Cloud")
                Spacer()
                GeometryReader { reader in
                VStack{
                    Picker("", selection: $unit) {
                        Text("C")
                            .tag(WeatherUnit.metric)
                        Text("F")
                            .tag(WeatherUnit.imperial)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .frame(width: 200)
                    
                    ScrollView(.vertical) {
                        VStack(){
                            if let data = manager.weather {
                                VStack {
                                    //Spacer()
                                    VStack(alignment: .leading, spacing: 20) {
                                        HStack{
                                            Text(locationCD[0].location ?? "--")
                                                .bold().font(.title)
                                                .padding(.bottom)

                                        }
                                        if let data = manager.weather?.forecast {
                                            HStack{
                                                ForEach (0..<6) { index in
                                                    let item2 = data[index]
                                                    
                                                    Text("")
                                                        .task{
                                                            //finding the max and min temp for the entire week
                                                            if count == 0{
                                                                self.min = Double(item2.minTemp)!
                                                                self.max = Double(item2.maxTemp)!
                                                            }
                                                            
                                                            if Double(item2.minTemp) ?? 0.0 < min {
                                                                self.min = Double(item2.minTemp)!
                                                            }
                                                            if Double(item2.maxTemp) ?? 0.0 > max {
                                                                self.max = Double(item2.maxTemp)!
                                                            }
                                                            
                                                            count = count + 1
                                                            if(count == 6){
                                                                reachEnd.toggle()
                                                                print(reachEnd)
                                                            }
                                                            
                                                            //setting width for the view based on screen height
                                                            width = reader.size.width
                                                            if width > 375 {
                                                                compWidth = 180
                                                            }else{
                                                                compWidth = 170
                                                            }
                                                            compWidth2 = (width / 3) - 15
                                                        }
                                                }
                                            }
                                            if reachEnd{
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
                                                            Text(item.weather.main ?? "--")
                                                                .font(.caption)
                                                                
                                                        }.frame(width: 50,alignment: .leading)
                                                        
                                                        VStack{
                                                            CircularProgressView(cMin: Double(item.minTemp)!, cMax: Double(item.maxTemp)!, min: self.min, max: self.max, unit: unitDisplay)
                                                        }.frame(width: compWidth, alignment: .trailing)
                                                        
                                                        Text("\(item.temp)")
                                                            .bold()
                                                            .font(.title)
                                                            .frame(width: 100 ,alignment: .trailing)
                                                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                                                    }
                                                    VStack{
                                                        HStack{
                                                            HStack{
                                                                Image(systemName: "cloud.fill")
                                                                    .foregroundColor(.gray)
                                                                Text("\(item.clouds)%")
                                                            }.frame(width: compWidth2)
                                                            HStack{
                                                                Image(systemName: "tornado")
                                                                    .foregroundColor(.gray)
                                                                Text("\(item.wind_speed)")
                                                            }.frame(width: compWidth2)
                                                            HStack{
                                                                Image(systemName: "drop")
                                                                    .foregroundColor(.blue)
                                                                    
                                                                Text("\(item.humidity)%")
                                                                    .onChange(of: unit.rawValue){ units in
                                                                        print(item.wind_speed.count)
                                                                            if unit.rawValue == "metric"{
                                                                                unitDisplay = "C"
                                                                            }else{
                                                                                unitDisplay = "F"
                                                                            }
                                                                        }
                                                            }.frame(width: compWidth2)
                                                        }
                                                    }
                                                    Divider().background(Color.gray)
                                                }
                                            }.onChange(of: unit) {_ in
                                                Task {
                                                    await manager.getFiveDayForecast(unit: self.unit,lat: locationCD[0].lat, lon: locationCD[0].lon )
                                                }
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
                            Task {
                                await manager.getFiveDayForecast(unit: self.unit,lat: locationCD[0].lat, lon: locationCD[0].lon )
                            }
                            
                        }
                    }
                    
                }
            }.navigationBarTitle("Mobile Weather")
            }
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}

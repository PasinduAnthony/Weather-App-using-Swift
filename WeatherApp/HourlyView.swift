//
//  HourlyView.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-18.
//

import SwiftUI

struct HourlyView: View {
    @FetchRequest(entity: Locations.entity(),sortDescriptors: []) var locationCD: FetchedResults<Locations>
    @State private var unit: WeatherUnit = .metric
    @StateObject private var manager = OneCallWeatherManager()
    @State private var temp = 0
    var locName = ""
    @Environment(\.rectangleSize) private var rectangleSize
    @StateObject private var viewModel = ContentViewModel()
    @State var lat : Double = 0.0
    @State var lon : Double = 0.0
    
    @Environment(\.lat) private var latEnv
    @Environment(\.lon) private var lonEnv
    var body: some View {
        NavigationView{
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            .environment(\.rectangleSize, true)
            LoopingPlayer().edgesIgnoringSafeArea(.all)
                .opacity(0.50)
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
                                    Text(locationCD[0].location ?? locName)
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
                                                //.padding()
//                                            VStack{
//                                                Text("o")
//                                                    .font(.system(size: 50))
//                                                    .fontWeight(.bold)
//                                                Text("C")
//                                                    .font(.system(size: 40))
//                                                    .fontWeight(.bold)
//                                                Text("")
//                                            }.frame(height: 100)
                                        }
                                        Spacer()
                                            
                                                            
                                        //Spacer()
                                        
                                    }.frame(maxWidth: .infinity)
                               
//                                    Text("\(current.dt)")
//                                    HStack {
//                                        Image(systemName: current.icon)
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 100, height: 100)
//                                        Text(current.temp)
//                                            .font(.system(size: 60, weight: .black, design: .rounded))
//                                            .foregroundColor(.yellow)
//                                    }
//                                    Text(current.weather.description)
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
                                            //Text("\(String(format: "%.1f", time[0]+1))")
                                            //Text("\Int(time[0])+1)")
                                            
                                        }//.listStyle(PlainListStyle())
                                        
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
                        await manager.getFiveDayForecast(unit: self.unit,lat: locationCD[0].lat, lon: locationCD[0].lon )
                    }
                }
                //            .onChange(of: unitEnv, perform: {unit in
                //
                //            })
                
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
//                                if let current = data.current {
//                                    //Text("\(current.dt)")
//                                    Text("\(current.dt)")
//                                        .onAppear{
//                                            let temp = current.dt
//                                            let temp2 = temp.components(separatedBy: " ")
//                                            let temp3 = temp2[2].components(separatedBy: ",")
//                                            let today = Date().formatted(.dateTime.day())
//                                            print("Temps : \(temp3[0])")
//                                            print("Today : \(today)")
//                                        }
//                                    HStack {
//                                        Image(systemName: current.icon)
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 100, height: 100)
//                                        Text(current.temp)
//                                            .font(.system(size: 60, weight: .black, design: .rounded))
//                                            .foregroundColor(.yellow)
//                                    }
//                                    Text(current.weather.description)
//                                }
                                
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
                                            await manager.getFiveDayForecast(unit: self.unit,lat: locationCD[0].lat, lon: locationCD[0].lon )
                                        }
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
//                    viewModel.cityText = locationCD[0].location ?? locName
//                    for item in viewModel.viewData{
//                    //forEach(viewModel.viewData) {item in
//                        lat = item.latitude
//                        lon = item.longitude
//                        print(item.latitude)
//
//                    }
                    print(lonEnv)
                    print(latEnv)
                    Task {
                        await manager.getFiveDayForecast(unit: self.unit,lat: locationCD[0].lat, lon: locationCD[0].lon )
                    }
                    
                }
                //            .onChange(of: unitEnv, perform: {unit in
                //
                //            })
                
                
            }//.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
            //.edgesIgnoringSafeArea(.all)
            
            
            
        }
        }.navigationBarHidden(true)
    }
}

struct HourlyView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView()
    }
}

//
//  HomeScreen.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-14.
//

import SwiftUI
import CoreLocationUI
import AVFoundation

struct HomeScreen: View{
    @FetchRequest(sortDescriptors: [SortDescriptor(\.isLive, order: .reverse)]) var locationCD: FetchedResults<Locations> //coredata read objects
    @State private var windDir = ""
    @State var vidName :String = ""
    
    var locName : String = "" //parameter for this view
    
    @StateObject var weather = WeatherManager() //one time api manager
    @State private var unit: WeatherUnit = .metric //defined in weather manager
    @State private var weatherUnit = false //local var
    @State private var navBarDisplay = false
    var body: some View {
        ZStack(){
            VideoBackgroundView(videoName: vidName.isEqual("") ? locationCD[0].vidName! : vidName)
                .onAppear{
                    if locName == ""{
                        navBarDisplay = true
                    }else{
                        navBarDisplay = false
                    }
                }
            GeometryReader { reader in //used to get the dimensions of the screen 
                VStack(alignment: .leading){
                    Spacer()
                    VStack(alignment: .leading, spacing: 5){
                        Text(weather.weather?.name ?? "--")
                            .bold().font(.title)
                            .task {
                                await weather.fetchForCurrentLocation(place: locName.isEmpty ? locationCD[0].location ?? "" : locName, unit:self.unit)
                            }
                        Text("Today, \(Date().formatted(.dateTime.month().hour().minute()))")
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    
                    
                    VStack{
                        HStack{
                            VStack(spacing: 20){
                                Image(systemName: weather.weather?.getIcon(id: weather.weather?.main ?? "Clear") ?? "cloud")
                                    .font(.system(size: 40))
                                Text(weather.weather?.main ?? "--") //Weather condition
                            }
                            .frame(width: 150, alignment: .leading)
                            
                            Spacer()
                            Text((weather.weather?.temperature.roundDouble() ?? "--")) //feels like
                                .font(.system(size: 95))
                                .fontWeight(.bold)
                            VStack{
                                Text("o")
                                    .font(.system(size: 50))
                                    .fontWeight(.bold)
                                Button{
                                }label: {
                                    Text(weatherUnit ? "F" : "C")
                                        .onTapGesture {
                                            weatherUnit.toggle()
                                            unit = .imperial
                                            
                                            Task{
                                                await weather.fetchForCurrentLocation(place: locName.isEmpty ? locationCD[0].location ?? "" : locName, unit: weatherUnit ? .imperial : .metric)
                                            }
                                            vidName = weather.weather?.getVideo(id: weather.weather?.main ?? "Clear") ?? "Cloud"
                                        }
                                        .foregroundColor(Color.blue)
                                        .font(.system(size: 40).bold())
                                }
                                Text("")
                            }.frame(height: 100)
                        }
                        Spacer()
                        Spacer()
                        
                    }.frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: (reader.size.height.isLess(than: 600) ? 0 : 20)) {
                        HStack{
                            Text("Weather now")
                                .bold()
                                .padding(.bottom)
                            if !locName.isEqual(""){
                                Button(action: {
                                }) {
                                    NavigationLink(destination: DetailView(locName: locName, vidName: vidName)) {
                                        Text("See All")
                                        Image(systemName: "chevron.right")
                                    }.navigationBarTitle("")
                                    
                                        .onTapGesture {
                                            navBarDisplay = true
                                        }
                                }
                                .padding(.bottom)
                                .frame(maxWidth: .infinity,alignment: .trailing)
                                .foregroundColor(Color.blue)
                            }
                            
                        }
                        
                        
                        HStack {
                            WeatherRow(logo: "thermometer.snowflake", name: "Temp", value: ((weather.weather?.temperature.roundDouble() ?? "--") + ("°")))
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.weather?.humidity ?? 0)%    ")
                        }
                        
                        HStack {
                            WeatherRow(logo: "digitalcrown.horizontal.press", name: "Pressure  ", value: "\(weather.weather?.pressure ?? 0)hPa")
                            Spacer()
                            WeatherRow(logo: "wind", name: "Wind speed    ", value: ((weather.weather?.windSpeed.roundDouble() ?? "--") + " m/s"))
                            
                            
                        }
                        HStack {
                            WeatherRow(logo: "cloud", name: "Cloud Perception", value: "\(weather.weather?.cloudPercentage ?? 0)%")
                            Spacer()
                            WeatherRow(logo: "tornado", name: "Wind Direction", value: weather.weather?.getWindDir ?? "--")
                        }
                    }//curve white box styling
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, CGFloat(reader.size.height.isLess(than: 650) ? 50 : 100)) //checks if the screen width is less than or greater than 650
                    .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                    .background(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    
                }
                
            }
            .edgesIgnoringSafeArea(.bottom) //white box to the end
            .preferredColorScheme(.dark) //select dark theme
        }
    }
}



struct HomeScreen_Preview: PreviewProvider{
    static var previews: some View{
        HomeScreen( vidName: "")
    }
}

//https://api.openweathermap.org/data/2.5/onecall?lat=7.291418&lon=80.636696&exclude=hourly&appid=8411d6b630a21808d9a80abfe90ec5fb    daily

//https://api.openweathermap.org/data/2.5/onecall?lat=7.291418&lon=80.636696&exclude=daily&appid=8411d6b630a21808d9a80abfe90ec5fb    hourly

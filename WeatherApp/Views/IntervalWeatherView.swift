//
//  IntervalWeatherView.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-22.
//

import SwiftUI

struct IntervalWeatherView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.isLive, order: .reverse)]) var locationCD: FetchedResults<Locations>
    @State private var unit: WeatherUnit = .metric
    @StateObject private var manager = OneCallWeatherManager()
    @State private var temp = 0
    
    var locName = ""  //parameter
    
    @State var width : CGFloat = 0  //screen size vars
    @State var compWidth : CGFloat = 0
    
    var body: some View {
        NavigationView{
            ZStack{
                VideoBackgroundView(videoName: locationCD[0].vidName ?? "Cloud")
                Spacer()
                GeometryReader { reader in
                    VStack{
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
                                                Text("\(current.dt)")
                                                    .fontWeight(.light)
                                                VStack{
                                                    HStack{
                                                        VStack(spacing: 20){
                                                            Image(systemName: current.icon)
                                                                .font(.system(size: 40))
                                                            Text(current.weather.description ?? "--") //Weather condition
                                                        }
                                                        .frame(width: 150, alignment: .leading)
                                                        .onAppear{
                                                            width = reader.size.width
                                                            if width > 375 {
                                                                compWidth = 180
                                                            }else{
                                                                compWidth = 160
                                                            }
                                                            print("width : \(width)")
                                                        }
                                                        
                                                        Spacer()
                                                        Text((current.temp ?? "--")) //feels like
                                                            .font(.system(size: 70))
                                                            .fontWeight(.bold)
                                                    }
                                                    Spacer()
                                                }.frame(maxWidth: .infinity)
                                            }
                                            ScrollView(.horizontal) {
                                                
                                                
                                                VStack(spacing: 10){
                                                    ForEach(data.hourlyForecasts) { item in
                                                        Divider().background(Color.gray)
                                                        HStack{
                                                            VStack{
                                                                Image(systemName: item.icon)
                                                                    .font(.title)
                                                                    .frame(width: 20, height: 20)
                                                                    .padding()
                                                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                                                                    .cornerRadius(50)
                                                            }.frame(width: 50,alignment: .trailing)
                                                            VStack{
                                                                Text(item.weather.description ?? "--")
                                                                    .font(.caption)
                                                                Text(item.dt)
                                                            }.frame(width: compWidth, alignment: .center)
                                                            VStack{
                                                                Text("\(item.temp)")
                                                                    .bold()
                                                                    .font(.title)
                                                                
                                                            }.frame(width: 100,alignment: .trailing)
                                                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 40))
                                                        }.frame(width: width)
                                                    }
                                                    Spacer()
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
                }
            }.navigationBarTitle("Hourly Forecast")
        }
    }
}

struct IntervalWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        IntervalWeatherView()
    }
}

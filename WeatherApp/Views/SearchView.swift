//
//  WelcomeView.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-15.
//

import SwiftUI
import CoreLocationUI
import CoreData
import AVFAudio

struct SearchView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.isLive, order: .reverse)]) var locationCD: FetchedResults<Locations> //fetches data from the database and order by live location
    @Environment(\.managedObjectContext) var moc //env object to save data to the database
    @EnvironmentObject var locationManage: LocationManager
    @State private var search:String = ""
    @State private var reload = false
    @StateObject private var viewModel = ContentViewModel() //search location
    
    @State private var name: String = ""
    @State private var name2: String = ""
    @State private var temp: String = ""
    @State private var desc: String = ""
    
    @StateObject var locationManager = LocationManager()
    @StateObject var weather = WeatherManager()
    @State private var height = 0
    
    @State private var weatherUnit = false
    @State private var showingAlert = false
    @State private var unit: WeatherUnit = .metric
    
    var livelat : Double //current location data
    var liveLon : Double
    var body: some View {
        NavigationView{
            VStack{
                List(viewModel.viewData) {item in
                    VStack(alignment: .leading){
                        Text(item.title)
                        Text(item.subtitle)
                            .foregroundColor(.secondary)
                        
                    }.onTapGesture {
                        reload = true
                        Task{
                            await weather.fetchForCurrentLocation(place: item.title, unit:self.unit)
                            name = weather.weather?.name ?? "--"
                            if(name == "--"){
                                showingAlert.toggle()
                            }
                            var isSaved = false
                            //adds the location to coredata if location has not being saved previously
                            //var str = "Hello, playground1"

//                            let decimalCharacters = CharacterSet.decimalDigits
//
//                            let decimalRange = name.rangeOfCharacter(from: decimalCharacters)
//
//                            if decimalRange != nil {
//                                print("Numbers found")
//                            }
                            
                            
                           
                            
                            for location in locationCD{
                                let letterCharacters = CharacterSet.letters
                                let nonLetterCharacters = letterCharacters.inverted
                                if(name != location.location) && !isSaved && (item.title != "The data couldn’t be read because it is missing.") && (item.title.rangeOfCharacter(from: nonLetterCharacters) == nil){
                                    let locationName = Locations(context: moc)
                                    locationName.location = item.title
                                    locationName.lat = item.latitude
                                    locationName.lon = item.longitude
                                    locationName.isLive = false
                                    locationName.vidName = weather.weather?.getVideo(id: weather.weather?.main ?? "Clear") ?? "Cloud"
                                    locationName.timezone = Int64(weather.weather?.timezone ?? 0)
                                    try? moc.save()
                                    isSaved = true
                                }else{
                                    isSaved = true
                                    showingAlert = true
                                }
                                
//                                if  {
//                                    showingAlert = true
//                                    print("Numbers found")
//                                }
                                
                            }
                            isSaved = false
                            //adds the location to coredata if there are no data
                            if (locationCD.isEmpty){
                                let locationName = Locations(context: moc)
                                locationName.location = item.title
                                locationName.lat = item.latitude
                                locationName.lon = item.longitude
                                locationName.vidName = weather.weather?.getVideo(id: weather.weather?.main ?? "Clear") ?? "Cloud"
                                locationName.isLive = false
                                locationName.timezone = Int64(weather.weather?.timezone ?? 0)
                                try? moc.save()
                            }
                            
                        }
                        
                        search = ""
                    }
                    
                }.searchable(text: $search)
                    .onChange(of: search, perform: {searchText in
                        if !searchText.isEmpty{
                            //contains search results
                            viewModel.cityText = search
                            height = 100 // sets the views height
                        }else{
                            //doesn't contains search results
                            viewModel.cityText = search
                            height = 0 // sets the views height
                        }
                    }).navigationBarTitle("Enter City")
                    .frame(width: UIScreen.main.bounds.width, height: CGFloat(height))
                    .alert(isPresented: $showingAlert) {
                                Alert(title: Text("Location Error"), message: Text("Having difficulties finding your location please. Enter another location"), dismissButton: .default(Text("Got it!")))
                            }//error alert from saving to coredata
                VStack{
                    if !livelat.isEqual(to: 0.0) && !liveLon.isEqual(to: 0.0){
                        Text("")
                            .hidden()
                            .onAppear{
                                Task{
                                    await weather.fetchForCurrentLocation(lat: livelat, lon: liveLon, unit: weatherUnit ? .imperial : .metric) //loads the live location data from api
                                    name2 = weather.weather?.name ?? "--"
                                    desc = weather.weather?.main ?? "--"
                                    temp = (weather.weather?.temperature.roundDouble() ?? "30")
                                    
                                    let locationName = Locations(context: moc)
                                    if (!locationCD.isEmpty){ //delete previous live location if contains
                                        for location in locationCD{
                                            if location.isLive{
                                                moc.delete(location)
                                                try? moc.save()
                                                print("deleted")
                                            }
                                        }
                                    }
                                    //saving live location to coredata
                                    locationName.location = name2
                                    locationName.lat = livelat
                                    locationName.lon = liveLon
                                    locationName.vidName = weather.weather?.getVideo(id: weather.weather?.main ?? "Clear") ?? "Cloud"
                                    locationName.isLive = true
                                    locationName.timezone = Int64(weather.weather?.timezone ?? 0)
                                    print("new rec : \(locationName)")
                                    try? moc.save()
                                }
                            }
                    }
                    
                    
                    
                    
                    List(locationCD, id: \.location) {loc in  //loads all the saved locations from coredata
                        VStack{
                            NavigationLink {
                                HomeScreen(vidName: weather.weather?.getVideo(id: weather.weather?.main ?? "Clear") ?? "Cloud" ?? "", locName:loc.location ?? "--")
                            } label: {
                                VStack(alignment: .leading){
                                    if loc.isLive{
                                        HStack{
                                            Text("Current Location")
                                                .bold().font(.title)
                                                .padding(.top, 5)
                                                .padding(.leading, 10)
                                            
                                            Label("", systemImage: "location.fill")
                                        }
                                        
                                        Text(loc.location ?? "--")
                                            .padding(.leading, 10)
                                    }else{
                                        Text(loc.location ?? "--")
                                            .bold().font(.title)
                                            .padding(.top, 20)
                                            .padding(.leading, 10)
                                    }
                                    
                                    
                                    HStack{
                                        VStack(spacing: 5){
                                            Image(systemName: loc.icon ?? "cloud")
                                                .font(.system(size: 40))
                                            Text(loc.desc ?? "--") //Weather condition
                                        }
                                        
                                        Spacer()
                                        Text(loc.temp ?? "--") //feels like
                                            .font(.system(size: 75))
                                            .fontWeight(.bold)
                                        //.padding()
                                        VStack{
                                            Text("o")
                                                .font(.system(size: 35))
                                                .fontWeight(.bold)
                                            Text("C")
                                                .font(.system(size: 25))
                                                .fontWeight(.bold)
                                            Text("")
                                        }//.frame(height: 100)
                                    }.padding(.leading, 10)
                                    Spacer()
                                    //}
                                    
                                }.onAppear{
                                    Task{
                                        await weather.fetchForCurrentLocation(place: loc.location ?? "", unit:weatherUnit ? .imperial : .metric)  //fetch weather data for location 
                                        name = weather.weather?.name ?? "--"
                                        loc.desc = weather.weather?.main ?? "--"
                                        loc.temp = (weather.weather?.temperature.roundDouble() ?? "30")
                                        
                                        //assigns image names 
                                        if(weather.weather?.main == "Thunderstorm"){
                                            loc.icon = "cloud.bolt.rain"
                                            loc.img = "RainySky"
                                            loc.vidName = "Lightning"
                                        }else if(weather.weather?.main == "Drizzle"){
                                            loc.icon = "cloud.drizzle"
                                            loc.img = "RainySky"
                                            loc.vidName = "Rain"
                                        }else if(weather.weather?.main == "Rain"){
                                            loc.icon = "cloud.rain"
                                            loc.img = "RainySky"
                                            loc.vidName = "Rain"
                                        }else if(weather.weather?.main == "Snow"){
                                            loc.icon = "snowflake"
                                            loc.img = "RainySky"
                                            loc.vidName = "Rain"
                                        }else if(weather.weather?.main == "Mist"){
                                            loc.icon = "cloud.fog"
                                            loc.img = "RainySky"
                                            loc.vidName = "Rain"
                                        }else if(weather.weather?.main == "Smoke"){
                                            loc.icon = "smoke"
                                            loc.img = "RainySky"
                                            loc.vidName = "Rain"
                                        }else if(weather.weather?.main == "Haze"){
                                            loc.icon = "tropicalstorm"
                                            loc.img = "RainySky"
                                            loc.vidName = "Lightning"
                                        }else if(weather.weather?.main == "Dust"){
                                            loc.icon = "tropicalstorm"
                                            loc.img = "RainySky"
                                            loc.vidName = "Rain"
                                        }else if(weather.weather?.main == "Fog"){
                                            loc.icon = "cloud.fog"
                                            loc.img = "RainySky"
                                            loc.vidName = "Rain"
                                        }else if(weather.weather?.main == "Sand"){
                                            loc.icon = "tropicalstorm"
                                            loc.img = "RainySky"
                                            loc.vidName = "Cloud"
                                        }else if(weather.weather?.main == "Ash"){
                                            loc.icon = "tropicalstorm"
                                            loc.img = "RainySky"
                                            loc.vidName = "Cloud"
                                        }else if(weather.weather?.main == "Squall"){
                                            loc.icon = "wind"
                                            loc.img = "RainySky"
                                            loc.vidName = "Rain"
                                        }else if(weather.weather?.main == "Tornado"){
                                            loc.icon = "tornado"
                                            loc.img = "RainySky"
                                            loc.vidName = "Cloud"
                                        }else if(weather.weather?.main == "Clear"){
                                            loc.icon = "sun.max"
                                            loc.img = "ClearSky"
                                            loc.vidName = "Cloud"
                                        }else if(weather.weather?.main == "Clouds"){
                                            loc.img = "RainySky"
                                            loc.icon = "cloud"
                                            loc.vidName = "Cloud"
                                        }
                                    }
                                }
                                .foregroundColor(Color.white)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        moc.delete(loc)
                                        try? moc.save()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                            }
                            .background(
                                Image(loc.img ?? "ClearSky")
                                    .resizable()
                                    .background(.black)
                                    .opacity(0.7)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width - 20)
                                    .cornerRadius(20)
                            )
                            
                            
                        }.swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            
                        }
                        .listStyle(.plain)
                        .listRowBackground(Color.clear)
                        .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width - 20, minHeight: 0, maxHeight: 150, alignment: .topLeading)
                        .cornerRadius(20)
                        .clipped()
                        
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
                    .toolbar{
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            LocationButton{
                                locationManage.requestLocation()
                            }.cornerRadius(20)
                                .labelStyle(.iconOnly)
                                .symbolVariant(.fill)
                                .foregroundColor(Color.white)
                        }
                    }
            }
            
        }.preferredColorScheme(.dark)
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(livelat: 0.0, liveLon: 0.0)
    }
}

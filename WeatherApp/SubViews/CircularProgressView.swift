//
//  CircularProgressView.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-23.
//

import SwiftUI

struct CircularProgressView: View {
    var cMin: Double
    var cMax: Double
    var min: Double
    var max: Double
    var unit: String
    @State var currentMin: Double = 0.0
    @State var currentMax: Double = 0.0
    
    var body: some View {
        
        ZStack{
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
                .opacity(0.2)
                .onAppear{
                    let temp = max - min
                    currentMin = ((cMin - min) / temp)
                    currentMax = (100 - (((self.max - cMax)/temp)*100)) / 100
                }
            
            // progress circle
            Circle()
                .trim(from: CGFloat(self.currentMin), to: CGFloat(self.currentMax))
                .stroke(AngularGradient(colors: [.blue,.indigo ,.orange, .pink, .red], center: .center), style: StrokeStyle(lineWidth: 20, lineCap: .butt, lineJoin: .miter))
                .rotationEffect(.degrees(-90))
            Text("L: \(self.cMin.roundDouble())°\(self.unit)\nH: \(self.cMax.roundDouble())°\(self.unit)")
                .font(.caption)
            
        }
        .frame(width: 90, height: 90)
        .padding()
    }
}



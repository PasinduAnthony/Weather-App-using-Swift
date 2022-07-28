//
//  LoadingProgress.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-15.
//

import SwiftUI

struct LoadingProgress: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LoadingProgress_Previews: PreviewProvider {
    static var previews: some View {
        LoadingProgress()
    }
}

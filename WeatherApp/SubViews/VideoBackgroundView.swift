//
//  test.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-23.
//

import SwiftUI
import AVFoundation

struct VideoBackgroundView: View {
    @State private var player = AVQueuePlayer()
    private let videoName: String
    
    public init(videoName: String) {
        self.videoName = videoName
    }
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            LoopingPlayer(videoName: videoName, player: player).edgesIgnoringSafeArea(.all)
                .opacity(0.50)
                .onAppear {
                    player.play()
                }
        }
    }
}

//struct test_Previews: PreviewProvider {
//    static var previews: some View {
//        test(videoName: "Rain")
//    }
//}

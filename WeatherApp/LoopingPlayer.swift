//
//  LoopingPlayer.swift
//  WeatherApp
//
//  Created by Pasindu on 2022-05-14.
//


import SwiftUI
import AVFoundation

struct LoopingPlayer: UIViewRepresentable {
    private let videoName: String
        private let player: AVQueuePlayer
        
        init(videoName: String, player: AVQueuePlayer) {
            self.videoName = videoName
            self.player = player
        }
        
        func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LoopingPlayer>) { }

        func makeUIView(context: Context) -> UIView {
            return PlayerUIView(videoName: videoName, player: player)
        }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Depending on your video you can select a proper `videoGravity` property to fit better
    init(videoName: String,
         player: AVQueuePlayer,
         videoGravity: AVLayerVideoGravity = .resizeAspectFill) {
        
        super.init(frame: .zero)
        
        guard let fileUrl = Bundle.main.url(forResource: videoName, withExtension: "mp4") else { return }
        let asset = AVAsset(url: fileUrl)
        let item = AVPlayerItem(asset: asset)
        
        player.isMuted = true // just in case
        playerLayer.player = player
        playerLayer.videoGravity = videoGravity
        layer.addSublayer(playerLayer)
        
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

//
//  AVPlayerView.swift
//  acbook
//
//  Created by tony on 21/2/2025.
//


import SwiftUI
import AVKit

struct AVPlayerView: View {
    let player: AVPlayer

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}

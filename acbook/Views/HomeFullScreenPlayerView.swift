//
//  FullScreenPlayerView 2.swift
//  acbook
//
//  Created by tony on 27/3/2025.
//


import AVKit
import AVFoundation
import SwiftUI

struct FullScreenPlayerView: View {
    @ObservedObject var viewModel: VideoViewModel
    let video: Video
    @State private var player: AVPlayer?
    @State private var currentVideoIndex: Int

    init(video: Video, viewModel: VideoViewModel) {
        self.video = video
        self.viewModel = viewModel
        // Find the index of the current video in the list
        if let index = viewModel.videos.firstIndex(where: { $0.id == video.id }) {
            _currentVideoIndex = State(initialValue: index)
        } else {
            _currentVideoIndex = State(initialValue: 0)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if let url = URL(string: video.hls_url) {
                    VideoPlayer(player: player)
                        .onAppear {
                            // Initialize AVPlayer with the video URL
                            player = AVPlayer(url: url)

                            // Set up audio session
                            do {
                                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                                try AVAudioSession.sharedInstance().setActive(true)
                            } catch {
                                print("Error setting up audio session: \(error)")
                            }

                            // Start the video
                            player?.play()
                        }
                        .onDisappear {
                            // Pause video when leaving full-screen view
                            player?.pause()
                        }
                        .gesture(
                            DragGesture().onEnded { value in
                                if value.translation.height < -100 { // Detect upward swipe
                                    nextVideo() // Switch to next video
                                }
                            }
                        )
                        .edgesIgnoringSafeArea(.all)  // Full-screen
                }
            }
            .navigationBarHidden(true)
        }
    }

    // Switch to the next video in the list
    private func nextVideo() {
        if currentVideoIndex + 1 < viewModel.videos.count {
            let nextVideo = viewModel.videos[currentVideoIndex + 1]
            currentVideoIndex += 1
            player?.replaceCurrentItem(with: AVPlayerItem(url: URL(string: nextVideo.hls_url)!))
            player?.play() // Play next video
        }
    }
}

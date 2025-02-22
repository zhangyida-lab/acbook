//
//
//  FullScreenPlayerView2.swift
//  acbook
//
//  Created by tony on 21/2/2025.
//


import AVKit
import AVFoundation
import SwiftUI

struct FullScreenPlayerView2: View {
    let video: Video
    @State private var player: AVPlayer?
    @State private var previousVideo: Video?
    @State private var nextVideo: Video?
    @State private var playerIndex: Int
    @State private var videos: [Video]

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
                                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: .allowAirPlay)
                                try AVAudioSession.sharedInstance().setActive(true)
                            } catch {
                                print("Error setting up audio session: \(error)")
                            }
                            
                            // Start playing the video
                            player?.play()
                        }
                        .onDisappear {
                            // Pause video when leaving full-screen view
                            player?.pause()
                            
                            // Deactivate the audio session when leaving the player
                            do {
                                try AVAudioSession.sharedInstance().setActive(false)
                            } catch {
                                print("Error deactivating audio session: \(error)")
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    // Check the direction of the swipe gesture
                                    if value.translation.height < 0 {
                                        // Swipe up, go to next video
                                        goToNextVideo()
                                    } else if value.translation.height > 0 {
                                        // Swipe down, go to previous video
                                        goToPreviousVideo()
                                    }
                                }
                        )
                        .edgesIgnoringSafeArea(.all)  // Make the video full-screen
                }
            }
            .navigationBarTitle("Video Player", displayMode: .inline)  // Show title in navigation bar
            .navigationBarItems(leading: Button(action: {
                // Action to dismiss the view
                // Automatically handled by NavigationLink
            }) {
                Image(systemName: "arrow.left.circle.fill")
                    .foregroundColor(.white)
            })
        }
        .onDisappear {
            // Pause and reset player when the view is dismissed
            player?.pause()
        }
    }
    
    // Go to the next video
    func goToNextVideo() {
        if playerIndex < videos.count - 1 {
            playerIndex += 1
            updatePlayer(with: videos[playerIndex])
        }
    }

    // Go to the previous video
    func goToPreviousVideo() {
        if playerIndex > 0 {
            playerIndex -= 1
            updatePlayer(with: videos[playerIndex])
        }
    }

    // Update player with a new video
    func updatePlayer(with video: Video) {
        if let url = URL(string: video.hls_url) {
            player = AVPlayer(url: url)
            player?.play()
        }
    }
}


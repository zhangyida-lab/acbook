import AVKit
import AVFoundation
import SwiftUI

struct FullScreenPlayerView: View {
    let video: Video
    @State private var player: AVPlayer?

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
                        .edgesIgnoringSafeArea(.all)  // Full-screen
                }
            }
            .navigationBarTitle("Video Player", displayMode: .inline)  // Show title in navigation bar
            .foregroundColor(.red)
            
            .navigationBarItems(leading: Button(action: {
                // Action to dismiss the view
                // Automatically handled by NavigationLink
            }) {
                Image(systemName: "arrow.left.circle.fill")
                    .foregroundColor(.white)
            })
        }
    }
}

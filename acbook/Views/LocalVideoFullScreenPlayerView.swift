import AVKit
import AVFoundation
import SwiftUI

struct LocalVideoFullScreenPlayerView: View {
    @StateObject private var viewModel = LocalVideoPlayerViewModel()  // 使用新的 ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // 如果没有视频文件，显示提示
                if viewModel.videoFiles.isEmpty {
                    Text("No videos found.")
                        .font(.title)
                        .padding()
                } else {
                    // 使用 VideoPlayer 播放视频
                    VideoPlayer(player: viewModel.player)
                        .onAppear {
                            // 在首次出现时加载视频文件
                            viewModel.fetchLocalVideos()
                        }
                        .onDisappear {
                            viewModel.player?.pause()  // 暂停视频
                        }
                        .gesture(
                            DragGesture().onEnded { value in
                                if value.translation.height < -80 {  // 向上滑动播放下一个视频
                                    viewModel.nextVideo()
                                } else if value.translation.height > 80 {  // 向下滑动播放上一个视频
                                    viewModel.previousVideo()
                                }
                            }
                        )
                        .edgesIgnoringSafeArea(.all)  // 全屏播放
                }
            }
        }
    }
}

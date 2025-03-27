import AVKit
import AVFoundation
import SwiftUI

struct HomeFullScreenPlayerView: View {
    @StateObject private var viewModel = VideoViewModel()  // 内部管理自己的数据模型
    @State private var player: AVPlayer?
    @State private var currentVideoIndex: Int = 0
    @State private var isLoading = true  // 加载状态
    @State private var cachedVideos: [Video] = []  // 缓存的前五个视频
    @State private var isPreloadingNextVideo = false  // 标记是否在预加载下一个视频
    @State private var showAlert = false  // 控制是否显示弹窗
    @State private var alertMessage = ""  // 弹窗信息

    // 自定义初始化方法，不再依赖外部传递的 viewModel
    init() {
        // 如果需要可以在这里进行一些初始化操作
    }

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading videos...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    if let video = viewModel.videos.first {
                        // 加载视频后，开始播放
                        VideoPlayer(player: player)
                            .onAppear {
                                startVideoPlayback(for: video)
                                preloadNextVideo()
                            }
                            .onDisappear {
                                // 暂停视频
                                player?.pause()
                            }
                            .gesture(
                                DragGesture().onEnded { value in
                                    if value.translation.height < -80 { // 向上滑动，播放下一个视频
                                        nextVideo()
                                    } else if value.translation.height > 80 { // 向下滑动，播放上一个视频
                                        previousVideo()
                                    }
                                }
                            )
                            .edgesIgnoringSafeArea(.all)  // 全屏播放
                    } else {
                        Text("No videos available.")
                            .padding()
                    }
                }
            }
            .onAppear {
                // 在视图显示时加载视频数据
                fetchVideos()
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("没有更多视频了"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("确定"))
                )
            }
        }
    }

    // 调用后台API获取视频列表并缓存前五个视频
    private func fetchVideos() {
        viewModel.fetchVideos()
        viewModel.$videos
            .sink { videos in
                if !videos.isEmpty {
                    self.isLoading = false
                    self.cachedVideos = Array(videos.prefix(5)) // 缓存前五个视频
                    self.currentVideoIndex = 0  // 默认播放第一个视频
                    preloadNextVideo()  // 预加载下一个视频
                }
            }
            .store(in: &viewModel.cancellables) // 存储Cancellable对象，保持订阅
    }

    // 开始播放视频
    private func startVideoPlayback(for video: Video) {
        if let url = URL(string: video.hls_url) {
            player = AVPlayer(url: url)
            player?.play()

            // 设置音频会话
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Error setting up audio session: \(error)")
            }
        }
    }

    // 预加载下一个视频
    private func preloadNextVideo() {
        if currentVideoIndex + 1 < cachedVideos.count && !isPreloadingNextVideo {
            isPreloadingNextVideo = true
            let nextVideo = cachedVideos[currentVideoIndex + 1]
            if let url = URL(string: nextVideo.hls_url) {
                // 异步加载下一个视频的部分内容来进行预缓存
                let asset = AVURLAsset(url: url)
                let playerItem = AVPlayerItem(asset: asset)
                
                // 开始加载，避免等待整个视频加载完成
                playerItem.preferredForwardBufferDuration = 5.0 // 设置预缓存时长

                // 加载数据
                let player = AVPlayer(playerItem: playerItem)
                player.play()
            }
        }
    }

    // 切换到下一个视频
    private func nextVideo() {
        // 停止当前视频的播放
        player?.pause()
        player = nil  // 释放播放器，防止下一个视频播放时仍然使用上一个播放器

        if currentVideoIndex + 1 < cachedVideos.count {
            // 更新到下一个视频
            let nextVideo = cachedVideos[currentVideoIndex + 1]
            currentVideoIndex += 1

            // 开始播放下一个视频
            startVideoPlayback(for: nextVideo)
            preloadNextVideo()  // 继续预加载下一个视频
        } else {
            // 如果没有更多的视频，显示弹窗
            alertMessage = "You have reached the end of the video list."
            showAlert = true
        }
    }

    // 切换到上一个视频
    private func previousVideo() {
        // 停止当前视频的播放
        player?.pause()
        player = nil  // 释放播放器，防止上一个视频播放时仍然使用当前播放器

        if currentVideoIndex - 1 >= 0 {
            // 更新到上一个视频
            let previousVideo = cachedVideos[currentVideoIndex - 1]
            currentVideoIndex -= 1

            // 开始播放上一个视频
            startVideoPlayback(for: previousVideo)
            preloadNextVideo()  // 继续预加载下一个视频
        } else {
            // 如果没有更多的视频，显示弹窗
            alertMessage = "首个视频"
            showAlert = true
        }
    }
}

import AVKit
import AVFoundation

class LocalVideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var videoFiles: [URL] = []  // 存储视频文件的 URL 列表
    @Published var currentVideoIndex: Int = 0
    @Published var isLoaded = false  // 用于标记视频是否已经加载

    // 获取 Document Directory 的路径
    private func getDocumentDirectoryURL() -> URL? {
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }

    // 加载本地视频文件
    func fetchLocalVideos() {
        guard !isLoaded else { return }  // 如果已经加载过视频，就跳过

        // 获取 Document Directory 路径
        guard let documentDirectoryURL = getDocumentDirectoryURL() else {
            print("Document Directory not found.")
            return
        }

        print("Document Directory URL: \(documentDirectoryURL.path)")  // 打印路径，查看是否正确

        do {
            // 获取 Document Directory 下的所有文件
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil)
            print("Files found in Document Directory: \(fileURLs)")  // 打印找到的文件列表

            // 筛选出 MP4 文件
            videoFiles = fileURLs.filter { $0.pathExtension.lowercased() == "mp4" }
            print("MP4 files: \(videoFiles)")  // 打印找到的 MP4 文件

            if videoFiles.isEmpty {
                // 如果没有视频文件，显示提示框
                print("No video files found.")
            } else {
                // 如果找到了视频文件，加载第一个视频
                startVideoPlayback(for: videoFiles[currentVideoIndex])
            }
            isLoaded = true  // 标记视频已加载
        } catch {
            print("Error reading video files: \(error)")  // 打印错误信息
        }
    }

    // 开始播放视频
    func startVideoPlayback(for videoURL: URL) {
        player = AVPlayer(url: videoURL)
        player?.play()
    }

    // 切换到下一个视频
    func nextVideo() {
        if currentVideoIndex + 1 < videoFiles.count {
            currentVideoIndex += 1
            startVideoPlayback(for: videoFiles[currentVideoIndex])
        }
    }

    // 切换到上一个视频
    func previousVideo() {
        if currentVideoIndex - 1 >= 0 {
            currentVideoIndex -= 1
            startVideoPlayback(for: videoFiles[currentVideoIndex])
        }
    }
}

import Foundation
import Combine
import SwiftUI

// 视频数据视图模型
class VideoViewModel: ObservableObject {
    @Published var videos = [Video]()
    @Published var isLoading = true
    private var searchCancellable: AnyCancellable? 
    
    // 获取视频列表
    func fetchVideos() {
        guard let url = URL(string: "\(Config.baseURL)/videos") else {
            print("Invalid URL")
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            print("Fetching videos...")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("Error fetching videos: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("No data received.")
                }
                return
            }
            
            // 打印响应数据
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
                print("Response headers: \(response.allHeaderFields)")
            }
            
            // 打印原始数据
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response data: \(jsonString)")
            }
            
            do {
                let decodedVideos = try JSONDecoder().decode([Video].self, from: data)
                print("Successfully decoded \(decodedVideos.count) videos.")
                
                // 替换每个视频的 hls_url 中的 localhost 为 config中设置的IP地址
                // 替换每个视频的thumbnail_url中的 localhost 为 config中设置的IP地址
                let updatedVideos = decodedVideos.map { video in
                    var updatedVideo = video
                    updatedVideo.hls_url = updatedVideo.hls_url.replacingOccurrences(of: "http://localhost:5000", with: "\(Config.baseURL)")
                    updatedVideo.thumbnail_url = updatedVideo.thumbnail_url.replacingOccurrences(of: "http://localhost:5000", with: "\(Config.baseURL)")
                    return updatedVideo
                }
                
                DispatchQueue.main.async {
                    self.videos = updatedVideos
                    self.isLoading = false
                    print("Videos updated and loaded.")
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("Error decoding video data: \(error)")
                }
            }
        }.resume()
    }

    // 点赞视频
    func likeVideo(videoId: Int) {
        guard let url = URL(string: "\(Config.baseURL)/like/\(videoId)") else {
            print("Invalid like URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        print("Sending like request for video ID: \(videoId)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error liking video: \(error.localizedDescription)")
                return
            }
            
            // 打印响应数据
            if let response = response as? HTTPURLResponse {
                print("Like response status code: \(response.statusCode)")
                print("Like response headers: \(response.allHeaderFields)")
            }
            
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                print("Like response data: \(jsonString)")
            }
            
            DispatchQueue.main.async {
                if let index = self.videos.firstIndex(where: { $0.id == videoId }) {
                    self.videos[index].likes += 1
                    print("Liked video ID \(videoId). New like count: \(self.videos[index].likes)")
                } else {
                    print("Video with ID \(videoId) not found.")
                }
            }
        }.resume()
    }
    
    
    
    
    
    // 根据搜索关键字获取视频
        func searchVideos(query: String) {
            guard !query.isEmpty else {
                fetchVideos()  // 如果搜索框为空，加载所有视频
                return
            }

            guard let url = URL(string: "\(Config.baseURL)/api/videos/search?q=\(query)") else { return }

            isLoading = true

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    print("Error fetching search results: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    print("No data received.")
                    return
                }

                do {
                    let decodedVideos = try JSONDecoder().decode([Video].self, from: data)
                    DispatchQueue.main.async {
                        self.videos = decodedVideos
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    print("Error decoding search results: \(error)")
                }
            }.resume()
        }
}

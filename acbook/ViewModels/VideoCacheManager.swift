//
//  VideoCacheManager.swift
//  acbook
//
//  Created by tony on 27/3/2025.
//


// VideoCacheManager.swift
import Foundation
import AVFoundation

// 视频缓存管理器
class VideoCacheManager {
    static let shared = VideoCacheManager()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    // 初始化
    private init() {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesDirectory.appendingPathComponent("videoCache")
        
        // 如果缓存目录不存在，则创建
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating cache directory: \(error)")
            }
        }
    }
    
    // 获取缓存目录路径
    func getCacheDirectory() -> URL {
        return cacheDirectory
    }
    
    // 获取文件夹大小
    func getFolderSize() -> Int64 {
        var folderSize: Int64 = 0
        if let enumerator = fileManager.enumerator(atPath: cacheDirectory.path) {
            for case let file as String in enumerator {
                let filePath = (cacheDirectory.path as NSString).appendingPathComponent(file)
                if let fileAttributes = try? fileManager.attributesOfItem(atPath: filePath),
                   let fileSize = fileAttributes[.size] as? Int64 {
                    folderSize += fileSize
                }
            }
        }
        return folderSize
    }
    
    // 清理缓存（删除超过阈值的缓存文件）
    func cleanCacheIfNeeded() {
        let cacheSize = getFolderSize()
        let maxCacheSize: Int64 = 1 * 1024 * 1024 * 1024  // 1 GB
        
        if cacheSize > maxCacheSize {
            // 清理缓存，这里可以根据策略删除文件，比如删除最旧的视频文件
            clearOldestCacheFiles()
        }
    }
    
    // 清理最旧的缓存文件
    private func clearOldestCacheFiles() {
        do {
            let files = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
            
            // 按照创建时间升序排序文件
            let sortedFiles = files.sorted { file1, file2 in
                let attributes1 = try? fileManager.attributesOfItem(atPath: file1.path)
                let attributes2 = try? fileManager.attributesOfItem(atPath: file2.path)
                
                if let date1 = attributes1?[.creationDate] as? Date,
                   let date2 = attributes2?[.creationDate] as? Date {
                    return date1 < date2
                }
                return false
            }
            
            // 删除最旧的文件
            if let fileToDelete = sortedFiles.first {
                try fileManager.removeItem(at: fileToDelete)
                print("Deleted cached video: \(fileToDelete.path)")
            }
        } catch {
            print("Error clearing cache: \(error)")
        }
    }
    
    // 下载并缓存视频文件
    func downloadAndCacheVideo(video: Video, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: video.hls_url) else {
            completion(nil)
            return
        }
        
        // 获取缓存路径
        let fileURL = cacheDirectory.appendingPathComponent("\(video.id).mp4")
        
        // 检查视频是否已经缓存
        if fileManager.fileExists(atPath: fileURL.path) {
            print("Video already cached: \(fileURL.path)")
            completion(fileURL)
            return
        }
        
        // 下载视频文件
        let task = URLSession.shared.downloadTask(with: url) { location, response, error in
            if let location = location, error == nil {
                do {
                    // 移动文件到缓存目录
                    try self.fileManager.moveItem(at: location, to: fileURL)
                    print("Video cached at: \(fileURL.path)")
                    self.cleanCacheIfNeeded()  // 清理缓存
                    completion(fileURL)
                } catch {
                    print("Error caching video: \(error)")
                    completion(nil)
                }
            } else {
                print("Failed to download video: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
        
        task.resume()
    }
}

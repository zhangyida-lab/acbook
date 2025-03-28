//
//  PoemViewModel.swift
//  acbook
//
//  Created by tony on 28/3/2025.
//


import Foundation

class PoemViewModel: ObservableObject {
    @Published var poems: [Poem] = []
    
    init() {
        loadPoems()
    }
    
    func loadPoems() {
        // 获取本地 JSON 文件的 URL
        guard let url = Bundle.main.url(forResource: "tangshi300", withExtension: "json") else {
            print("JSON 文件未找到")
            return
        }
        
        do {
            // 读取文件内容
            let jsonData = try Data(contentsOf: url)
            
            // 使用 JSONDecoder 解析 JSON 数据
            let decoder = JSONDecoder()
            let decodedPoems = try decoder.decode([Poem].self, from: jsonData)
            self.poems = decodedPoems
        } catch {
            print("加载或解析 JSON 文件时出错: \(error)")
        }
    }
}

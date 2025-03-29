import Foundation

class PoemViewModel: ObservableObject {
    @Published var poems: [Poem] = []
    
    // 控制当前资源文件的名称
    @Published var resourceName: String = "songci300_with_ids"
    
    init() {
        loadPoems()
    }
    
    func loadPoems() {
        // 根据 resourceName 动态获取资源文件
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json") else {
            print("JSON 文件未找到: \(resourceName)")
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedPoems = try decoder.decode([Poem].self, from: jsonData)
            self.poems = decodedPoems
            sortPoems()  // 默认加载后按标题排序
        } catch {
            print("加载或解析 JSON 文件时出错: \(error)")
        }
    }
    
    // 排序诗词
    func sortPoems() {
        // 假设你默认按标题排序
        poems.sort { $0.title < $1.title }
    }
    
    // 切换资源文件
    func switchResource() {
        if resourceName == "songci300_with_ids" {
            resourceName = "tangshi300"
        } else {
            resourceName = "songci300_with_ids"
        }
        loadPoems()  // 切换后重新加载诗词
    }
}

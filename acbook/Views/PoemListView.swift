import SwiftUI

struct PoemListView: View {
    @StateObject var viewModel = PoemViewModel()
    
    // 定义两列布局
    let columns = [
        GridItem(.flexible()), // 第一列
        GridItem(.flexible())  // 第二列
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // 主要的内容区域
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.poems) { poem in
                            NavigationLink(destination: PoemDetailView(poem: poem)) {
                                VStack(alignment: .leading) {
                                    Text(poem.title)
                                        .font(.headline)
                                    Text(poem.author)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    HStack {
                                        ForEach(poem.tags, id: \.self) { tag in
                                            Text(tag)
                                                .font(.caption)
                                                .padding(4)
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 4)
                            }
                        }
                    }
                    .padding()
                }
                
                // 圆形按钮，两个按钮上下排列
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 20) {
                            // 随机打乱按钮
                            Button(action: {
                                // 随机打乱诗词数组
                                viewModel.poems.shuffle()
                            }) {
                                Image(systemName: "shuffle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            }
                            
                            // 切换资源文件按钮
                            Button(action: {
                                // 切换资源文件
                                viewModel.switchResource()
                            }) {
                                Image(systemName: "folder.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            }
                        }
                        .padding()
                    }
                }
                
            }
            .navigationTitle("诗词列表")
        }
    }
}

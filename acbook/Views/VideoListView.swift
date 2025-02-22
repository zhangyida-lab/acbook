import SwiftUI

struct VideoListView: View {
    @StateObject private var viewModel = VideoViewModel()
    @State private var searchText: String = ""  // 搜索文本
    @State private var searchTimer: Timer?  // 用于防抖处理
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading videos...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                VStack {
                    HStack {
                        TextField("Search videos...", text: $searchText)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .padding(.top,30)
                            .onChange(of: searchText) {
                                searchTimer?.invalidate() // 取消上一个计时器
                                // 启动新的计时器，防止频繁请求
                                searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                    if searchText.isEmpty {
                                        viewModel.fetchVideos() // 如果搜索框为空，加载所有视频
                                    } else {
                                        viewModel.searchVideos(query: searchText) // 启动搜索
                                    }
                                }
                            }
                    }
                    .padding(.top) // 确保搜索框不会被其他元素遮挡

                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.videos) { video in
                                VideoItemView(video: video)
                                    .aspectRatio(16/9, contentMode: .fit) // 　保持16:9的宽高比
                                    .padding(.bottom, 10) // 给每个视频项增加底部间距
                            }
                        }
                        .padding([.leading, .trailing])
                        .onAppear {
                            if viewModel.videos.isEmpty {
                                viewModel.fetchVideos() // 初次加载视频
                            }
                        }
                    }
                    .padding(.bottom)  // 防止底部被遮挡
                    .refreshable {
                        viewModel.fetchVideos()  // 下拉刷新
                    }
                }
                .edgesIgnoringSafeArea(.top)  // 防止顶部被遮挡
            }
        }
        .onAppear {
            if viewModel.videos.isEmpty {
                viewModel.fetchVideos() // 初次加载视频
            }
        }
    }
}

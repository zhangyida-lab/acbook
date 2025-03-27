import SwiftUI
import AVKit

struct VideoItemView: View {
    let video: Video
    
    var body: some View {
        NavigationLink(destination: FullScreenPlayerView(video: video)) {
            GeometryReader { geometry in
                VStack {
                    // 异步加载视频缩略图
                    AsyncImage(url: URL(string: video.thumbnail_url)) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width - 30, height: (geometry.size.width - 30) * 9 / 16) // 设置宽度和高度（16:9比例）
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                            .frame(width: geometry.size.width - 30, height: (geometry.size.width - 30) * 9 / 16)
                    }
                    
                    
                    
                    
                    Text(video.filename)
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(.top, 5)
                }
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
            .frame(height: 250) // 设置整体的高度
        }
    }
}

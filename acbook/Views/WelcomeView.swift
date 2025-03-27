import SwiftUI

struct WelcomeView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("张菻然的娱乐空间")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Image(systemName: "tree.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .foregroundColor(.green)
                    .padding()
                    .shadow(color: .gray, radius: 10, x: 5, y: 5) // 为图标添加阴影
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 强制VStack填充整个屏幕
            .background(Color.blue.opacity(0.4))
            .edgesIgnoringSafeArea(.all)  // 忽略安全区，背景占满整个屏幕
        }
    }
}

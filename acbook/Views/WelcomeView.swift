struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("欢迎使用我们的应用！")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()

            Text("正在加载...")
                .padding()
        }
        .background(Color.blue.opacity(0.1))  // 背景颜色可自定义
        .edgesIgnoringSafeArea(.all)  // 忽略安全区
    }
}

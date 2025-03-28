//
//  ContentView.swift
//  acbook
//
//  Created by tony on 21/2/2025.
//


//正常tabview 经过测试了

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        NavigationView {
//            TabView {
//                VideoListView(filter: { _ in true })
//                    .tabItem {
//                        Label("All Videos", systemImage: "video")
//                    }
//
//                VideoListView(filter: { video in
//                    video.type == "象棋"
//                })
//                .tabItem {
//                    Label("Comedy", systemImage: "play.circle")
//                }
//
//                VideoListView(filter: { video in
//                    video.type == "搞笑"
//                })
//                .tabItem {
//                    Label("Popular", systemImage: "star.fill")
//                }
//            }
//            .accentColor(.blue)
//        }
//    }
//}



// 添加验证密码对特有的tabview
import SwiftUI

struct ContentView: View {
    @State private var showPasswordAlert = false  // 是否显示密码输入框
    @State private var enteredPassword = ""  // 用户输入的密码
    @State private var isPasswordCorrect = false  // 是否验证通过
    @State private var isLoading = true  // 是否正在加载

    var body: some View {
        ZStack {
            // 当正在加载时，显示欢迎界面
            if isLoading {
                WelcomeView()
            } else {
                NavigationView {
                    TabView {
                        // 首页Tab：显示所有视频
//                        VideoListView(filter: { _ in true })
//                            .tabItem {
//                                Label("首页", systemImage: "video")
//                            }
                        
                        
                        LocalVideoFullScreenPlayerView()
                        .tabItem {
                            Label("学习", systemImage: "flag.2.crossed.fill")
                            }

                        // 学习 Tab
                        VideoListView(filter: { video in
                            video.type == "象棋"
                        })
                        .tabItem {
                            Label("学习", systemImage: "flag.2.crossed.fill")
                        }

                        
                        // 唐诗三百首Tab
                        PoemListView()
                            .tabItem {
                                Label("诗词", systemImage: "book.fill")
                            }
                        // 竖滑动短视频tab
                        HomeFullScreenPlayerView()
                            .tabItem {
                                Label("短视频", systemImage: "infinity")
                            }

                        // 收藏 Tab：点赞数多的视频
                        VideoListView(filter: { video in
                            video.likes > 100
                        })
                        .tabItem {
                            Label("收藏", systemImage: "star.fill")
                        }
                        
                        
                        // 娱乐 Tab
                        NavigationView {
                            if isPasswordCorrect {
                                // 密码验证通过，显示视频内容
                                VideoListView(filter: { video in
                                    video.type == "kbj"
                                })
                            } else {
                                // 密码验证未通过，显示密码输入界面
                                PasswordView(isPasswordCorrect: $isPasswordCorrect)
                            }
                        }
                        .tabItem {
                            Label("娱乐", systemImage: "play.circle")
                        }
                        
                    }
                    .accentColor(.blue)
                }
            }
        }
        .onAppear {
            // 模拟后台加载数据，2秒后结束加载
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading = false
            }
        }
    }
}




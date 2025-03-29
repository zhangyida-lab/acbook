import SwiftUI
import PhotosUI

struct MyImageView: View {
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]
    
    @State private var photos = [UIImage]() // Storing actual UIImage objects
    
    @State private var selectedPhoto: UIImage? // Selected photo for full-screen view
    @State private var isFullScreen = false // Control full-screen view
    @State private var currentIndex = 0 // Current image index
    
    @State private var selectedItems: [PhotosPickerItem] = [] // Selected items
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    if photos.isEmpty {
                        Text("没有照片，点击下面的按钮添加照片")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        ForEach(photos, id: \.self) { photo in
                            Image(uiImage: photo)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .onTapGesture {
                                    selectedPhoto = photo
                                    currentIndex = photos.firstIndex(of: photo) ?? 0
                                    isFullScreen = true
                                }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("照片展示")
            .sheet(isPresented: $isFullScreen) {
                if let selectedPhoto = selectedPhoto {
                    FullScreenImageView(
                        currentImage: selectedPhoto,
                        photos: $photos,
                        currentIndex: $currentIndex
                    )
                }
            }
        }
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        photos.shuffle()
                    }) {
                        Text("🔀")
                            .font(.largeTitle)
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(16)
                    
                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 1, matching: .images) {
                        Text("➕")
                            .font(.largeTitle)
                            .frame(width: 50, height: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .onChange(of: selectedItems) {
                        Task {
                            guard let item = selectedItems.first else { return }
                            do {
                                // Load the selected image data
                                if let data = try await item.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    photos.append(uiImage)
                                }
                            } catch {
                                print("Error loading image: \(error.localizedDescription)")
                            }
                        }
                    }
                    .padding(16)
                }
            }
        )
    }
}

struct FullScreenImageView: View {
    let currentImage: UIImage
    @Binding var photos: [UIImage] // Binding to photos array
    @Binding var currentIndex: Int
    
    var body: some View {
        ZStack {
            Image(uiImage: currentImage)
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.height < 0 {
                                if currentIndex < photos.count - 1 {
                                    currentIndex += 1
                                }
                            } else if value.translation.height > 0 {
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                }
                            }
                        }
                )
            
            // Show image index (optional)
            Text("\(currentIndex + 1) / \(photos.count)")
                .foregroundColor(.white)
                .font(.title)
                .padding()
        }
    }
}

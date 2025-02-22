//
//  ContentView.swift
//  acbook
//
//  Created by tony on 21/2/2025.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VideoListView()
                .statusBar(hidden: true)
        }
    }
}

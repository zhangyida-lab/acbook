//
//  PoemDetailView.swift
//  acbook
//
//  Created by tony on 28/3/2025.
//


import SwiftUI

struct PoemDetailView: View {
    var poem: Poem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(poem.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("作者: \(poem.author)")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(poem.paragraphs, id: \.self) { paragraph in
                        Text(paragraph)
                            .font(.body)
                            .padding(.bottom, 10)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("标签:")
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack {
                        ForEach(poem.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(6)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.top, 30)
            }
            .padding()
        }
    }
}

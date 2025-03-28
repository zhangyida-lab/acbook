//
//  Poem.swift
//  acbook
//
//  Created by tony on 28/3/2025.
//


import Foundation

struct Poem: Identifiable, Codable {
    var id: String
    var author: String
    var paragraphs: [String]
    var tags: [String]
    var title: String
}

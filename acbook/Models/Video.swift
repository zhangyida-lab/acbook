//
//  Video.swift
//  acbook
//
//  Created by tony on 21/2/2025.
//


import Foundation

struct Video: Identifiable, Decodable {
    var id: Int
    var filename: String
    var hls_url: String
    var likes: Int
    var thumbnail_url: String
}

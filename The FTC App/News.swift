//
//  News.swift
//  The FTC App
//
//  Created by Jining Liu on 8/16/25.
//

import Foundation

struct News: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String?
    let tags: [Tag]
    let markdown: String?
    let url: URL?
    let date: Date
}

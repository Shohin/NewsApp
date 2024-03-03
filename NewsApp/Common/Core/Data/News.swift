//
//  News.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

struct News: Hashable {
    let id: String
    let imgURL: String?
    let title: String
    let author: String?
    let desc: String?
    let content: String?
    let publishedAt: Date
}

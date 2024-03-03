//
//  RNews.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation
import RealmSwift

final class RNews: Object {
    @Persisted(primaryKey: true) var id = ""
    @Persisted var title = ""
    @Persisted var imgURL: String? = nil
    @Persisted var author: String? = nil
    @Persisted var desc: String? = nil
    @Persisted var content: String? = nil
    @Persisted var publishedAt = Date()
    
    @Persisted var bookmarked = false
}

extension RNews: DataTransformer {
    convenience init(from data: News) {
        self.init()
        id = data.id
        title = data.title
        imgURL = data.imgURL
        author = data.author
        desc = data.desc
        content = data.content
        publishedAt = data.publishedAt
    }
    
    func transform() -> News {
        News(id: id, imgURL: imgURL, title: title, author: author, desc: desc, content: content, publishedAt: publishedAt)
    }
}

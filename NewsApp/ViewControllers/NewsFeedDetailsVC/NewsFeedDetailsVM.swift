//
//  NewsFeedDetailsVM.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 03/03/24.
//

import Foundation

protocol NewsFeedDetailsDelegate: AnyObject {
    func closeTapped()
}

final class NewsFeedDetailsVM {
    weak var delegate: NewsFeedDetailsDelegate?
    
    private let news: News
    private let bookmarker: BookmarkableProtocol
    init(news: News, bookmarker: BookmarkableProtocol) {
        self.news = news
        self.bookmarker = bookmarker
    }
    
    var imgURL: URL? {
        URL(string: news.imgURL ?? "")
    }
    
    var title: String {
        news.title
    }
    
    var text: String? {
        news.desc ?? news.content
    }
    
    var author: String? {
        news.author
    }
    
    var publishedAtText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM.dd,yyyy"
        return formatter.string(from: news.publishedAt)
    }
    
    var isBookmarked: Bool { bookmarker.isBookmarked(newsID: news.id) }
    
    func bookmark(isBookmarked: Bool) {
        bookmarker.bookmark(news: news, isBookmarked: isBookmarked)
    }
}

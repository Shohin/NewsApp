//
//  BookmarkableProtocol.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

protocol BookmarkableProtocol {
    @discardableResult
    func bookmark(news: News, isBookmarked: Bool) -> Bool
    func isBookmarked(newsID: String) -> Bool
}

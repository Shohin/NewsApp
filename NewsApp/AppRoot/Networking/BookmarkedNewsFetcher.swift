//
//  BookmarkedNewsFetcher.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

final class BookmarkedNewsFetcher: NewsListFetcherProtocol {
    private let storage: RStorageService
    init(storage: RStorageService = .shared) {
        self.storage = storage
    }
    
    func fetchNews(searchText: String?, limit: Int, page: Int, completion: @escaping (Result<NewsFetchResult, NewsListFetcherError>) -> Void) {
        let news: [RNews] = storage.fetchData()
        let resultNews = news.filter {
            $0.bookmarked
            && (searchText ?? "").isEmpty ? true :  $0.title.contains(searchText ?? "")
        }.map { $0.transform() }
        let result = NewsFetchResult(news: resultNews, totalResultsCount: resultNews.count)
        completion(.success(result))
    }
}

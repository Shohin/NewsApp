//
//  NewsFeedVM.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

struct NewsFeedPresenter {
    private let news: News
    let isBookmarked: Bool
    init(news: News, isBookmarked: Bool) {
        self.news = news
        self.isBookmarked = isBookmarked
    }
    
    var id: String { news.id }
    
    var imgURL: String? { news.imgURL }
    
    var title: String { news.title }
    
    var author: String? { news.author }
    
    var publishedAt: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter.string(from: news.publishedAt)
    }
}

enum NewsFeedFetchType {
    case all
    case bookmarked
}

final class NewsFeedVM {
    private(set) var feeds = [News]()
    
    private var pagination = Pagination(limit: 20, page: 1, totalResultsCount: 20)
    
    private let fetchType: NewsFeedFetchType
    private let feedFetcher: NewsListFetcherProtocol
    private let bookmarker: BookmarkableProtocol
    init(
        fetchType: NewsFeedFetchType,
        feedFetcher: NewsListFetcherProtocol,
        bookmarker: BookmarkableProtocol
    ) {
        self.fetchType = fetchType
        self.feedFetcher = feedFetcher
        self.bookmarker = bookmarker
    }
    
    var hasNextPage: Bool { pagination.hasNextPage }
    
    func fetchFeeads(completion: @escaping (String?) -> Void) {
        pagination.offset = 0
        pagination.page = 1
        feeds = []
        fetchFeeadsCore(completion: completion)
    }
    
    func fetchMoreFeeds(completion: @escaping (String?) -> Void) {
        pagination.page += 1
        fetchFeeadsCore(completion: completion)
    }
    
    func newsFeedPresenter(news: News) -> NewsFeedPresenter {
        NewsFeedPresenter(
            news: news,
            isBookmarked: bookmarker.isBookmarked(newsID: news.id)
        )
    }
    
    func bookmark(news: News, isBookmarked: Bool) -> Bool {
        bookmarker.bookmark(news: news, isBookmarked: isBookmarked)
    }
    
    private func fetchFeeadsCore(completion: @escaping (String?) -> Void) {
        feedFetcher.fetchNews(limit: pagination.limit, page: pagination.page) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(let fetchResult):
                self.feeds.insert(contentsOf: fetchResult.news, at: self.pagination.offset)
                self.pagination.offset = self.feeds.count
                self.pagination = self.pagination.copyWith(totalResultsCount: fetchResult.totalResultsCount)
                DispatchQueue.main.async {
                    completion(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(error.message)
                }
            }
        }
    }
}

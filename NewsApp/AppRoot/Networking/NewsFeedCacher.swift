//
//  NewsFeedCacher.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

final class NewsFeedCacher: NewsListFetcherProtocol {
    private let cacher: RStorageService
    private let fetcher: NewsListFetcherProtocol
    init(
        cacher: RStorageService = .shared,
        fetcher: NewsListFetcherProtocol
    ) {
        self.cacher = cacher
        self.fetcher = fetcher
    }
    
    func fetchNews(searchText: String?, limit: Int, page: Int, completion: @escaping (Result<NewsFetchResult, NewsListFetcherError>) -> Void) {
        fetcher.fetchNews(searchText: searchText, limit: limit, page: page) {[weak self] result in
            switch result {
            case .success(let res):
                self?.saveOnlyMissed(result: res)
                completion(result)
            case .failure(let error):
                switch error {
                case .network,
                        .loadingFailed:
                    self?.cacher.fetchNews(searchText: searchText, limit: limit, page: page, completion: completion)
                default:
                    completion(result)
                }
                
            }
        }
    }
    
    private func saveOnlyMissed(result: NewsFetchResult) {
        let rnews: [RNews] = cacher.fetchData()
        let rSet = Set(rnews.map { $0.transform() })
        let nSet = Set(result.news)
        try? cacher.save(data: nSet.subtracting(rSet).map { RNews(from: $0) })
    }
}

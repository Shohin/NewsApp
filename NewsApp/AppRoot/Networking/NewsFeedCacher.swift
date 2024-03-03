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
    
    func fetchNews(limit: Int, page: Int, completion: @escaping (Result<NewsFetchResult, NewsListFetcherError>) -> Void) {
        fetcher.fetchNews(limit: limit, page: page) {[weak self] result in
            switch result {
            case .success(let result):
                self?.saveOnlyMissed(result: result)
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
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

//
//  NewsListFetcherProtocol.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

enum NewsListFetcherError: Error {
    case invalidURL
    case invalidJSONFormat
    case message(String)
    case network(Error)
    case loadingFailed
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid url"
        case .invalidJSONFormat:
            return "Invalid json format"
        case .message(let msg):
            return msg
        case .network(_):
            return "Networking error"
        case .loadingFailed:
            return "Loading failed"
        }
    }
}

struct NewsFetchResult {
    let news: [News]
    let totalResultsCount: Int
}

protocol NewsListFetcherProtocol {
    func fetchNews(searchText: String?, limit: Int, page: Int, completion: @escaping (Result<NewsFetchResult, NewsListFetcherError>) -> Void)
}

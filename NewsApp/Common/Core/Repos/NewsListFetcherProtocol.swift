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
}

protocol NewsListFetcherProtocol {
    func fetchNews(completion: @escaping (Result<[News], NewsListFetcherError>) -> Void)
}

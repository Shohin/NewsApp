//
//  URLSessionNewsFetcher.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

final class URLSessionNewsFetcher: NewsListFetcherProtocol {
    func fetchNews(searchText: String?, limit: Int, page: Int, completion: @escaping (Result<NewsFetchResult, NewsListFetcherError>) -> Void) {
        var urlStr = "https://newsapi.org/v2/top-headlines?country=us&apiKey=1b835322859d405e9e529f0282efaf6d&pageSize=\(limit)&page=\(page)"
        if let searchText,
           !searchText.isEmpty {
            urlStr.append("&q=\(searchText)")
        }
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            self?.handleCompletion(data: data, error: error, completion: completion)
        }
        
        task.resume()
    }
    
    private func handleCompletion(data: Data?, error: Error?, completion: @escaping (Result<NewsFetchResult, NewsListFetcherError>) -> Void) {
        if let data {
            completion(parseData(data))
        } else {
            if let error {
                completion(.failure(.network(error)))
            } else {
                completion(.failure(.loadingFailed))
            }
        }
    }
    
    private func parseData(_ data: Data) -> Result<NewsFetchResult, NewsListFetcherError> {
        do {
            let decoder = JSONDecoder()

            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate]

            decoder.dateDecodingStrategy = .custom({ decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                if let date = formatter.date(from: dateString) {
                    return date
                }
                
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
            })
            
            let newsResponse = try decoder.decode(NewsResponse.self, from: data)
            if newsResponse.status == "ok",
               let articles = newsResponse.articles {
                return .success(NewsFetchResult(news: articles.compactMap { $0.news }, totalResultsCount: newsResponse.totalResults ?? 0) )
            } else if let errorMsg = newsResponse.message {
                return .failure(.message(errorMsg))
            } else {
                return .failure(.loadingFailed)
            }
        } catch {
            return .failure(.invalidJSONFormat)
        }
    }
}

private struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int?
    let code: String?
    let message: String?
    let articles: [ArticleResponse]?
}

private struct ArticleResponse: Decodable {
    let url: String
    let author: String?
    let title: String?
    let description: String?
    let urlToImage: String?
    let content: String?
    let publishedAt: Date?
    
    var news: News? {
        guard let title,
              let publishedAt else {
            return nil
        }
        
        return News(id: url, imgURL: urlToImage, title: title, author: author, desc: description, content: content, publishedAt: publishedAt)
    }
}

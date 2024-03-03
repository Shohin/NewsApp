//
//  Pagination.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 03/03/24.
//

import Foundation

struct Pagination {
    var offset = 0
    let limit: Int
    var page: Int
    let totalResultsCount: Int
    
    var hasNextPage: Bool {
        limit * page < totalResultsCount
    }
    
    func copyWith(totalResultsCount: Int) -> Pagination {
        Pagination(offset: offset, limit: limit, page: page, totalResultsCount: totalResultsCount)
    }
}

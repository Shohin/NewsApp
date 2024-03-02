//
//  DataTransformer.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

protocol DataTransformer {
    associatedtype T
    init(from data: T)
    func transform() -> T
}

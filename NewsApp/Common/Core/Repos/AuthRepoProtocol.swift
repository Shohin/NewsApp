//
//  AuthRepoProtocol.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

protocol AuthRepoProtocol {
    func logout(completion: @escaping (Bool) -> Void)
}

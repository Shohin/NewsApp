//
//  UserRepoProtocol.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

enum AuthError: Error {
    case wrongCredentials
}

protocol UserLoginRepoProtocol {
    func login(credentials: UserCredentials, completion: @escaping (Result<UserCredentials, AuthError>) -> Void)
}

protocol UserRegisterRepoProtocol {
    func register(credentials: UserCredentials, completion: (Result<UserCredentials, AuthError>) -> Void)
}

typealias UserRepoProtocol = UserLoginRepoProtocol & UserRegisterRepoProtocol

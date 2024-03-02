//
//  KeychainUserLoginProvider.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

final class KeychainUserLoginProvider: UserLoginRepoProtocol {
    private let repo: UserLoginRepoProtocol
    private let keychainService: KeychainService
    init(repo: UserLoginRepoProtocol,
         keychainService: KeychainService = .shared) {
        self.repo = repo
        self.keychainService = keychainService
    }
    
    func login(credentials: UserCredentials, completion: @escaping (Result<UserCredentials, AuthError>) -> Void) {
        repo.login(credentials: credentials) { [weak self] result in
            switch result {
            case .success(let savedCredentials):
                if self?.keychainService.save(credentials: savedCredentials) == nil {
                    completion(.failure(AuthError.wrongCredentials))
                } else {
                    completion(.success(savedCredentials))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

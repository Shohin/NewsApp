//
//  LoginVM.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 01/03/24.
//

import Foundation

protocol LoginDelegate: AnyObject {
    func loginSucceed(credentials: UserCredentials)
}

final class LoginVM {
    private(set) lazy var model = LoginModel()
    
    weak var delegate: LoginDelegate?
    
    private let loginProvider: UserLoginRepoProtocol
    init(loginProvider: UserLoginRepoProtocol) {
        self.loginProvider = loginProvider
    }
    
    func login(completionFailed: @escaping (String) -> Void) { //Error message
        loginProvider.login(credentials: UserCredentials(username: model.username ?? "", password: model.password ?? "")) {[weak self] result in
            switch result {
            case .success(let credentials):
                self?.delegate?.loginSucceed(credentials: credentials)
            case .failure(let error):
                completionFailed(error.message)
            }
        }
    }
}

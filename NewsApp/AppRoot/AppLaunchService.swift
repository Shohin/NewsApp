//
//  AppLaunchService.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 01/03/24.
//

import Foundation
import UIKit

final class AppLaunchService {
    static let shared = AppLaunchService()
    
    private var window: UIWindow?
    
    func launch() {
        setupStorage()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let keychainService = KeychainService.shared
        if let credentials = keychainService.fetchCredentials() {
            showHomeVC(credentials: credentials)
        } else {
            showLoginVC()
        }
    }
    
    private func setupStorage() {
        RStorageService.shared.setupDefault()
        RStorageService.shared.saveDemoUsersOnNeed()
    }
    
    private func showHomeVC(credentials: UserCredentials) {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        window?.rootViewController = vc
    }
    
    private func showLoginVC() {
        let vm = LoginVM(loginProvider: KeychainUserLoginProvider(repo: RStorageService.shared))
        vm.delegate = self
        let vc = LoginVC(vm: vm)
        window?.rootViewController = vc
    }
}

extension AppLaunchService: LoginDelegate {
    func loginSucceed(credentials: UserCredentials) {
        showHomeVC(credentials: credentials)
    }
}

fileprivate extension RStorageService {
    func saveDemoUsersOnNeed() {
        let users: [RUser] = fetchData()
        if users.isEmpty {
            register(credentials: .init(username: "usera", password: "passworda")) { _ in }
            register(credentials: .init(username: "userb", password: "passwordb")) { _ in }
        }
    }
}

extension RStorageService: UserRepoProtocol {
    func login(
        credentials: UserCredentials,
        completion: @escaping (Result<UserCredentials, AuthError>) -> Void
    ) {
        let users: [RUser] = fetchData()
        if let credentials = users.first(where: { user in
            user.username.compare(credentials.username) == .orderedSame
            && PasswordEncryptor.comparePasword(encodedPassword: user.password, decodedPassword: credentials.password)
        })?.transform() {
            completion(.success(credentials))
        } else {
            completion(.failure(.wrongCredentials))
        }
    }
    
    func register(credentials: UserCredentials, completion: (Result<UserCredentials, AuthError>) -> Void) {
        do {
            try save(data: RUser(from: credentials))
            completion(.success(credentials))
        } catch {
            completion(.failure(.wrongCredentials))
        }
    }
}

extension AuthError {
    var message: String {
        switch self {
        case .wrongCredentials:
            return "Wrong credentials"
        }
    }
}

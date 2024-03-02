//
//  LoginModel.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 01/03/24.
//

import Foundation

enum LoginValidationError: Error {
    case invalidUsername
    case invalidPassword
    
    var message: String {
        switch self {
        case .invalidUsername:
            return "Invalid username"
        case .invalidPassword:
            return "Invalid password"
        }
    }
}

final class LoginModel {
    var username: String?
    var password: String?
    
    func validate() throws {
        try validateUsername()
        try validatePassword()
    }
    
    func validateUsername() throws {
        guard let username,
              !username.isEmpty,
              username.count > 2 else {
            throw LoginValidationError.invalidUsername
        }
    }
    
    func validatePassword() throws {
        guard let password,
              !password.isEmpty,
              password.count > 5 else {
            throw LoginValidationError.invalidPassword
        }
    }
}

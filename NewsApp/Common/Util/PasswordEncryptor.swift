//
//  PasswordEncryptor.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

enum PasswordEncryptor {
    static func encodePassword(_ password: String) -> String {
        password.base64Encoded() ?? ""
    }
    
    static func decodePassword(_ encodedPassword: String) -> String {
        encodedPassword.base64Decoded() ?? ""
    }
    
    static func comparePasword(encodedPassword: String, decodedPassword: String) -> Bool {
        decodePassword(encodedPassword).compare(decodedPassword) == .orderedSame
    }
}

//
//  RUser.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation
import RealmSwift

final class RUser: Object {
    @Persisted(primaryKey: true) var username = ""
    @Persisted var password = "" //password in base64 binary string format for security purpose
}

extension RUser: DataTransformer {
    convenience init(from data: UserCredentials) {
        self.init()
        username = data.username
        password = PasswordEncryptor.encodePassword(data.password)
    }
    
    func transform() -> UserCredentials {
        UserCredentials(username: username, password: PasswordEncryptor.decodePassword(password))
    }
}

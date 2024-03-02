//
//  KeychainService.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

final class KeychainService {
    static let shared = KeychainService()
    
    func save(credentials: UserCredentials) -> UserCredentials? {
        guard let passwordData = credentials.password.data(using: .utf8) else { return nil }
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: credentials.username,
            kSecValueData as String: passwordData,
        ]
        let status = SecItemAdd(attributes as CFDictionary, nil)
        if status == noErr {
            debugPrint("User saved successfully in the keychain")
            return credentials
        } else {
            debugPrint("Something went wrong trying to save the user in the keychain. Error: \(status)")
            return nil
        }
    }
    
    func fetchCredentials() -> UserCredentials? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?
        // Check if user exists in the keychain
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr,
           let existingItem = item as? [String: Any],
           let username = existingItem[kSecAttrAccount as String] as? String,
           let passwordData = existingItem[kSecValueData as String] as? Data,
           let password = String(data: passwordData, encoding: .utf8) {
            return UserCredentials(username: username, password: password)
        } else {
            debugPrint("Something went wrong trying to find the user in the keychain")
            return nil
        }
    }
    
    func deleteCredentials() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        // Find user and delete
        if SecItemDelete(query as CFDictionary) == noErr {
            debugPrint("User removed successfully from the keychain")
            return true
        } else {
            debugPrint("Something went wrong trying to remove the user from the keychain")
            return false
        }
    }
    
    private init() {}
}

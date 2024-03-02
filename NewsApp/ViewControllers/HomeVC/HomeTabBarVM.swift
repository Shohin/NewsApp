//
//  HomeTabBarVM.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation

protocol HomeTabBarDelegate: AnyObject {
    func logout()
    func searchTyping(searchText: String?)
}

final class HomeTabBarVM {
    weak var delegate: HomeTabBarDelegate?
    
    private let credentials: UserCredentials
    init(credentials: UserCredentials) {
        self.credentials = credentials
    }
    
    var avatarTitle: String {
        credentials.username.last?.uppercased() ?? ""
    }
}

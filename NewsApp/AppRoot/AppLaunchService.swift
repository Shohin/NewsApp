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
    
    private var rootNavigationVC: UINavigationController? {
        window?.rootViewController as? UINavigationController
    }
    
    private var homeVC: HomeTabBarVC? { rootNavigationVC?.topViewController as? HomeTabBarVC }
     
    let newsApi = URLSessionNewsFetcher()
    
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
        let homeVC = makeHomeTabBarVC(credentials: credentials)
        homeVC.view.backgroundColor = .white
        homeVC.tabBar.unselectedItemTintColor = .gray
        
        let topHeadlinesVC = makeNewsFeedVC(fetchType: .all)
        topHeadlinesVC.tabBarItem = UITabBarItem(title: "Top Headlines", image: UIImage(named: "globe"), tag: 0)
        
        let savedNewsVC = makeNewsFeedVC(fetchType: .bookmarked)
        savedNewsVC.tabBarItem = UITabBarItem(title: "Saved News", image: UIImage(named: "bookmark"), tag: 1)
        
        homeVC.viewControllers = [topHeadlinesVC, savedNewsVC]
        
        window?.rootViewController = UINavigationController(rootViewController: homeVC)
    }
    
    private func showLoginVC() {
        let vm = LoginVM(loginProvider: KeychainUserLoginProvider(repo: RStorageService.shared))
        vm.delegate = self
        let vc = LoginVC(vm: vm)
        window?.rootViewController = vc
    }
    
    private func makeNewsFeedVC(fetchType: NewsFeedFetchType) -> UIViewController {
        let fetcher: NewsListFetcherProtocol
        switch fetchType {
        case .all:
            fetcher = NewsFeedCacher(fetcher: URLSessionNewsFetcher())
        case .bookmarked:
            fetcher = BookmarkedNewsFetcher()
        }
        
        let vm = NewsFeedVM(
            fetchType: fetchType,
            feedFetcher: fetcher,
            bookmarker: RStorageService.shared
        )
        vm.delegate = self
        let vc = NewsFeedVC(vm: vm)
        vc.view.backgroundColor = .white
        return vc
    }
    
    private func makeHomeTabBarVC(credentials: UserCredentials) -> HomeTabBarVC {
        let vm = HomeTabBarVM(credentials: credentials)
        vm.delegate = self
        return HomeTabBarVC(vm: vm)
    }
}

extension AppLaunchService: LoginDelegate {
    func loginSucceed(credentials: UserCredentials) {
        showHomeVC(credentials: credentials)
    }
}

extension AppLaunchService: HomeTabBarDelegate {
    func logout() {
        if KeychainService.shared.deleteCredentials() {
            do {
                try RStorageService.shared.deleteAll(object: RNews.self)
                showLoginVC()
            } catch {
                debugPrint("Error on deleting news: \(error)")
            }
        }
    }
    
    func searchTyping(searchText: String?) {
        (homeVC?.selectedViewController as? NewsFeedVC)?.searchFeeds(searchText: searchText)
        debugPrint("Search text: \(searchText ?? "Empty")")
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

extension RStorageService: NewsListFetcherProtocol {
    func fetchNews(searchText: String?, limit: Int, page: Int, completion: @escaping (Result<NewsFetchResult, NewsListFetcherError>) -> Void) {
        var rnews: [RNews] = fetchData()
        if let searchText,
           !searchText.isEmpty {
            rnews = rnews.filter { $0.title.contains(searchText) }
        }
        let result = NewsFetchResult(
            news: rnews.map { $0.transform() },
            totalResultsCount: rnews.count
        )
        completion(.success(result))
    }
}

extension RStorageService: BookmarkableProtocol {
    func bookmark(news: News, isBookmarked: Bool) -> Bool {
        let rnews = fetchData(id: news.id) ?? RNews(from: news)
        do {
            try safeUpdate {
                rnews.bookmarked = isBookmarked
            }
            try save(data: rnews)
            return true
        } catch {
            debugPrint("Bookmarking feed failed. Feed: \(rnews)\n\(error)")
            return false
        }
    }
    
    func isBookmarked(newsID: String) -> Bool {
        let news: RNews? = fetchData(id: newsID)
        return news?.bookmarked ?? false
    }
}

extension AppLaunchService: NewsFeedDelegate {
    func selectedFeed(_ feed: News) {
        let vm = NewsFeedDetailsVM(news: feed, bookmarker: RStorageService.shared)
        vm.delegate = self
        let vc = NewsFeedDetailsVC(vm: vm)
        vc.modalPresentationStyle = .fullScreen
        rootNavigationVC?.present(vc, animated: true)
    }
}

extension AppLaunchService: NewsFeedDetailsDelegate {
    func closeTapped() {
        rootNavigationVC?.dismiss(animated: true)
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

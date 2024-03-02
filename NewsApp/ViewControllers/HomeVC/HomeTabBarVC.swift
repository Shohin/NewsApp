//
//  HomeTabBarVC.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation
import UIKit

final class HomeTabBarVC: UITabBarController {
    private let vm: HomeTabBarVM
    init(vm: HomeTabBarVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = "Search"
        
        setupAvatar()
        setupLogout()
        setupSearchController()
    }
    
    private func setupAvatar() {
        let labelSize: CGFloat = 40
        let avatarLabel = UILabel()
        avatarLabel.text = vm.avatarTitle
        avatarLabel.textAlignment = .center
        avatarLabel.frame.size = CGSize(width: labelSize, height: labelSize)
        avatarLabel.layer.cornerRadius = labelSize / 2
        avatarLabel.clipsToBounds = true
        avatarLabel.backgroundColor = UIColor.white
        avatarLabel.layer.borderWidth = 1
        avatarLabel.layer.borderColor = UIColor.black.cgColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: avatarLabel)
    }
    
    private func setupLogout() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setImage(UIImage(named: "logout")?.withRenderingMode(.alwaysOriginal), for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logoutButton)
    }
    
    private func setupSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    //MARK: actions
    @objc
    private func logoutAction() {
        showQuickConfirmAlert(message: "Do you really want to logout?") {[weak self] in
            self?.vm.delegate?.logout()
        }
    }
}

extension HomeTabBarVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        vm.delegate?.searchTyping(searchText: searchController.searchBar.text)
    }
}

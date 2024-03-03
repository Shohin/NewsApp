//
//  NewsFeedVC.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation
import UIKit

final class NewsFeedVC: UITableViewController {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var emptyLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.text = "News feed is empty"
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.isHidden = true
        return lbl
    }()
    
    private let vm: NewsFeedVM
    init(vm: NewsFeedVM) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNewsFeed()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func searchFeeds(searchText: String?) {
        refreshControl?.beginRefreshing()
        vm.fetchFeeds(searchText: searchText) {[weak self] errorMsg in
            self?.refreshControl?.endRefreshing()
            self?.handleFetchFeedCompletion(errorMsg: errorMsg)
        }
    }
    
    private func setup() {
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefreshAction), for: .valueChanged)
        self.refreshControl = refreshControl
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive = true
    }
    
    private func fetchNewsFeed() {
        activityIndicator.startAnimating()
        vm.fetchFeeds {[weak self] errorMsg in
            self?.activityIndicator.stopAnimating()
            self?.handleFetchFeedCompletion(errorMsg: errorMsg)
        }
    }
    
    private func handleFetchFeedCompletion(errorMsg: String?) {
        if errorMsg == nil {
            tableView.reloadData()
        } else {
            showQuickAlert(title: "Loading news failed", message: errorMsg)
        }
        emptyLabel.isHidden = !vm.feeds.isEmpty
    }
    
    //MARK: actions
    @objc
    private func pullToRefreshAction() {
        vm.fetchFeeds {[weak self] errorMsg in
            self?.refreshControl?.endRefreshing()
            self?.handleFetchFeedCompletion(errorMsg: errorMsg)
        }
    }
}

extension NewsFeedVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        vm.hasNextPage ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.feeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cellID = String(describing: NewsFeedLoadMoreTableViewCell.self)
            var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
            if cell == nil {
                cell = NewsFeedLoadMoreTableViewCell(reuseIdentifier: cellID)
            }
            return cell!
        }
        
        let cellID = String(describing: NewsFeedTableViewCell.self)
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? NewsFeedTableViewCell
        if cell == nil {
            cell = NewsFeedTableViewCell(reuseIdentifier: cellID)
        }
        
        cell?.delegate = self
        cell?.updateUI(presenter: vm.newsFeedPresenter(news: vm.feeds[indexPath.row]), indexPath: indexPath)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if vm.hasNextPage,
           indexPath.row > vm.feeds.count - 2 {
            vm.fetchMoreFeeds {[weak self] errorMsg in
                self?.handleFetchFeedCompletion(errorMsg: errorMsg)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("Selected feed: \(vm.feeds[indexPath.row])")
    }
}

extension NewsFeedVC: NewsFeedTableViewCellDelegate {
    func bookmarkChanged(indexPath: IndexPath, isBookmarked: Bool) {
        let succeed = vm.bookmark(news: vm.feeds[indexPath.row], isBookmarked: isBookmarked)
        guard succeed else { return }
        switch vm.fetchType {
        case .all:
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .bookmarked:
            fetchNewsFeed()
        }
    }
}

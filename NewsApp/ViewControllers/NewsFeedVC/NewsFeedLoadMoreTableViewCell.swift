//
//  NewsFeedLoadMoreTableViewCell.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 03/03/24.
//

import Foundation
import UIKit

final class NewsFeedLoadMoreTableViewCell: UITableViewCell {
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init(reuseIdentifier: String) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectionStyle = .none
        
        contentView.addSubview(activityIndicator)
        
        setupLayout()
    }
    
    private func setupLayout() {
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

//
//  NewsFeedTableViewCell.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 02/03/24.
//

import Foundation
import UIKit

protocol NewsFeedTableViewCellDelegate: AnyObject {
    func bookmarkChanged(indexPath: IndexPath, isBookmarked: Bool)
}

final class NewsFeedTableViewCell: UITableViewCell {
    private lazy var imgView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 8
        imgView.backgroundColor = .red
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bottomStackView)
        return stackView
    }()
    
    private lazy var authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 16)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(publishedAtLabel)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(bookmarkButton)
        return stackView
    }()
    
    private lazy var publishedAtLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "bookmark-outlined"), for: .normal)
        btn.setImage(UIImage(named: "bookmark"), for: .selected)
        btn.addTarget(self, action: #selector(bookmarkAction), for: .touchUpInside)
        btn.tintColor = .black
        return btn
    }()
    
    private var indexPath: IndexPath?
    
    weak var delegate: NewsFeedTableViewCellDelegate?
    
    init(reuseIdentifier: String) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectionStyle = .none
        
        contentView.addSubview(imgView)
        contentView.addSubview(containerStackView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        imgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor, multiplier: 1).isActive = true
        
        containerStackView.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 8).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32).isActive = true
        containerStackView.topAnchor.constraint(equalTo: imgView.topAnchor, constant: 8).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: imgView.bottomAnchor).isActive = true
    }
    
    func updateUI(presenter: NewsFeedPresenter, indexPath: IndexPath) {
        authorLabel.text = presenter.author
        titleLabel.text = presenter.title
        publishedAtLabel.text = presenter.publishedAt
        bookmarkButton.isSelected = presenter.isBookmarked
        self.indexPath = indexPath
    }
    
    //MARK: actions
    @objc
    private func bookmarkAction() {
        bookmarkButton.isSelected = !bookmarkButton.isSelected
        if let indexPath {
            delegate?.bookmarkChanged(indexPath: indexPath, isBookmarked: bookmarkButton.isSelected)
        }
    }
}

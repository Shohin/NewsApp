//
//  NewsFeedDetailsVC.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 03/03/24.
//

import Foundation
import UIKit

final class NewsFeedDetailsVC: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imgView)
        view.addSubview(topStackView)
        view.addSubview(titleLabel)
        view.addSubview(bottomStackView)
        view.addSubview(textLabel)
        return view
    }()
    
    private lazy var imgView: UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.backgroundColor = .red
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.addSublayer(imgViewGradientLayer)
        return imgView
    }()
    
    private lazy var imgViewGradientLayer: CAGradientLayer = {
       let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.6).cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.7, 1]
        return gradientLayer
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(bookmarkButton)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(closeButton)
        return stackView
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "bookmark-outlined")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setImage(UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .selected)
        btn.addTarget(self, action: #selector(bookmarkAction), for: .touchUpInside)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 24, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(calendarImgView)
        stackView.addArrangedSubview(publishedAtLabel)
        return stackView
    }()
    
    private lazy var authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    private lazy var calendarImgView: UIImageView = {
       let imgView = UIImageView(image: UIImage(named: "calendar"))
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var publishedAtLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 12)
        return lbl
    }()
    
    private lazy var textLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let vm: NewsFeedDetailsVM
    init(vm: NewsFeedDetailsVM) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgViewGradientLayer.frame = imgView.bounds
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        imgView.loadImage(url: vm.imgURL)
        bookmarkButton.isSelected = vm.isBookmarked
        titleLabel.text = vm.title
        authorLabel.text = vm.author
        publishedAtLabel.text = vm.publishedAtText
        textLabel.text = vm.text
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        ])
        
        let contentViewCenterY = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        contentViewCenterY.priority = .defaultLow

        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow

        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentViewCenterY,
            contentViewHeight
        ])
        
        imgView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
        topStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        topStackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        topStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        titleLabel.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -8).isActive = true
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: topStackView.bottomAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        bottomStackView.bottomAnchor.constraint(equalTo: imgView.bottomAnchor).isActive = true
        bottomStackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        bottomStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        calendarImgView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        calendarImgView.heightAnchor.constraint(equalTo: calendarImgView.widthAnchor, multiplier: 1).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 16).isActive = true
        textLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    //MARK: actions
    @objc
    private func bookmarkAction() {
        bookmarkButton.isSelected = !bookmarkButton.isSelected
        vm.bookmark(isBookmarked: bookmarkButton.isSelected)
    }
    
    @objc
    private func closeAction() {
        vm.delegate?.closeTapped()
    }
}

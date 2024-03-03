//
//  UIImageViewExtensions.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 03/03/24.
//

import Foundation
import UIKit
import Kingfisher

//TODO: should be moved to Application root
extension UIImageView {
    func loadImage(url: URL?) {
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: UIImage(named: "feed-placeholder")
        )
    }
}

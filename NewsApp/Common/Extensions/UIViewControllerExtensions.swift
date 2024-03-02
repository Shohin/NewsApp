//
//  UIViewControllerExtensions.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 01/03/24.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboard() {
        view.hideKeyboard()
    }
    
    func showQuickAlert(
        title: String? = nil,
        message: String?
    ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alertVC, animated: true)
    }
}

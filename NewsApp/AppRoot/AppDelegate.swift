//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Shohin Tagaev on 01/03/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppLaunchService.shared.launch()
        return true
    }
}

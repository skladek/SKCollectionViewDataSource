//
//  AppDelegate.swift
//  SampleProject
//
//  Created by Sean on 6/8/17.
//  Copyright © 2017 Sean Kladek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: HomeViewController())
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        return true
    }
}


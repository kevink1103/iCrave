//
//  AppDelegate.swift
//  iCrave
//
//  Created by Kevin Kim on 15/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Load dummies
        loadDummyCategories()
        loadDummyRecords()
        // WishItem.deleteAll()
        // FirebaseApp.configure() // Firebase Integration
        return true
    }

    // MARK: UISceneSession Lifecycle
    //
    // func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    //     // Called when a new scene session is being created.
    //     // Use this method to select a configuration to create the new scene with.
    //     return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    // }
    //
    // func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    //     // Called when the user discards a scene session.
    //     // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    //     // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    // }

}

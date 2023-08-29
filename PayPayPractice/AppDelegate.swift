//
//  AppDelegate.swift
//  PayPayPractice
//
//  Created by Tony Mu on 29/08/23.
//

import UIKit
import AppCenter
import AppCenterCrashes
import AppCenterAnalytics

/*
 Find uuid for dsym
 mdfind "com_apple_xcode_dsym_uuids == 7323-323-23-3-324234"
 */

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        AppCenter.start(withAppSecret: "a9e12a6a-42b5-4d4c-b8d4-8011df266c87", services: [Analytics.self, Crashes.self])
        
        print("Had crash: \(Crashes.hasCrashedInLastSession)")
        return true
    }
}

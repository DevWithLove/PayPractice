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
 
 In termail see build list
 xcrun xcodebuild -list
 
 Run uitest from cml
 xcrun xcodebuild build-for-testing -configuration Debug -project PayPayPractice.xcodeproj -sdk iphoneos -scheme PayPayPractice -derivedDataPath DerivedData -allowProvisioningUpdates
 
once the test runed, we can use DerivedData/Build/Products/Debug-iphoneos/ as test directory for appCenter test
 */

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        AppCenter.start(withAppSecret: "d496189c-de02-406f-86e7-0c2e634d081e", services: [Analytics.self, Crashes.self])
        
        print("Had crash: \(Crashes.hasCrashedInLastSession)")
        return true
    }
}

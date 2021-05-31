//
//  AppDelegate.swift
//  HSSDKSwiftUISample
//
//  Created by Sagar Dagdu on 28/05/21.
//

import UIKit
import HelpshiftX

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #warning("TODO: To start using this project, copy-paste your APP_ID as the value of hsPlatformId and comment this line")
            let hsPlatformId = "";

        #warning("TODO: To start using this project, copy-paste your DOMAIN as the value of hsDomain and comment this line")
            let hsDomain = "";

//        Helpshift.install(withPlatformId: hsPlatformId, domain: hsDomain, config: nil)
            
        // Set the delegate
        Helpshift.sharedInstance().delegate = HelpshiftEventsHandler.shared;
        
        registerForPush()
        
        //handle when app is not in background and opened for push notification
        if let launchOptions = launchOptions {
            if let userInfo = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable:Any], let origin = userInfo["origin"] as? String, origin == "helpshift" {
                Helpshift.handleNotification(withUserInfoDictionary: userInfo, isAppLaunch: true, with: UIUtils.rootViewController()!)
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//MARK:- Push Notifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerForPush() {
        #if targetEnvironment(simulator)
        // there is no push on simulator so skip
        #else
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else {
                print("Error while requesting Notification permissions.")
                return
            }
            
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        #endif
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Helpshift.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error in registering for remote notifications: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let origin = userInfo["origin"] as? String, origin == "helpshift" {
            print("userNotificationCenter:willPresentNotification for helpshift origin")
            Helpshift.handleNotification(withUserInfoDictionary: userInfo, isAppLaunch: false, with: UIUtils.rootViewController()!)
        }
        
        completionHandler([])
    }
    
}

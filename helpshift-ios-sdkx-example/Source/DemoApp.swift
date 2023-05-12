//
//  DemoApp.swift
//  Copyright © 2023 Helpshift. All rights reserved.
//

import SwiftUI
import HelpshiftX

typealias AppData = DemoAppData

@main
struct DemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if !AppData.domain.isEmpty && !AppData.platformId.isEmpty {
            let config = ["enableLogging": true]
            Helpshift.install(withPlatformId: AppData.platformId,
                              domain: AppData.domain,
                              config: config)
            AppData.applyToSdk()
        }
        registerForPush()
        return true
    }

    func registerForPush() {
#if targetEnvironment(simulator)
        // there is no push on simulator so skip
#else
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            if let error = error {
                NSLog("Error while requesting notification permissions: \(error.localizedDescription)")
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
#endif
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Helpshift.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications! Error : \(error.localizedDescription)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        if let origin = userInfo["origin"] as? String, origin == "helpshift" {
            print("userNotificationCenter:willPresentNotification for helpshift origin.")
            Helpshift.handleNotification(withUserInfoDictionary: userInfo,
                                         isAppLaunch: false,
                                         with: UIApplication.shared.rootViewController)
            return []
        } else if let proactiveLink = userInfo["helpshift_proactive_link"] as? String {
            Helpshift.handleProactiveLink(proactiveLink)
        }
        return [.banner, .sound]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        if let origin = userInfo["origin"] as? String, origin == "helpshift" {
            print("userNotificationCenter:didReceiveResponse for helpshift origin.")
            Helpshift.handleNotification(withUserInfoDictionary: userInfo,
                                         isAppLaunch: true,
                                         with: UIApplication.shared.rootViewController)
        } else if let proactiveLink = userInfo["helpshift_proactive_link"] as? String {
            Helpshift.handleProactiveLink(proactiveLink)
        }
    }
}

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
    }

    var rootViewController: UIViewController {
        guard let vc = currentKeyWindow?.rootViewController else {
            fatalError("Root view controller is nil. This should never happen.")
        }
        return vc
    }
}

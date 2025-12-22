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
            .navigationViewStyle(.stack)
            .onOpenURL { url in
                DeepLinkHandler.handle(url)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    // Dependencies
    let helpshiftConfig = HelpshiftProactiveConfig()
    let helpshiftDelegates = HelpshiftDelegates()
    let notificationHandler = NotificationHandler()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Helpshift.install(withPlatformId: AppData.platformId,
                          domain: AppData.domain,
                          config: ["enableLogging": true]) // Should be `false` in production
        Helpshift.sharedInstance().delegate = helpshiftDelegates
        Helpshift.sharedInstance().proactiveAPIConfigCollectorDelegate = helpshiftConfig
        AppData.applyToSdk()
        notificationHandler.registerForPush()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        notificationHandler.handleRegister(deviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        notificationHandler.handleRegisterFail(error: error)
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any]
    ) async -> UIBackgroundFetchResult {
        return await notificationHandler.handleRemoteNotification(userInfo)
    }
}

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
            }.navigationViewStyle(.stack)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static let closeSession = "closeSessionNotification"
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Helpshift.install(withPlatformId: AppData.platformId,
                          domain: AppData.domain,
                          config: installConfig())
        Helpshift.sharedInstance().delegate = self
        Helpshift.sharedInstance().proactiveAPIConfigCollectorDelegate = self
        AppData.applyToSdk()
        registerForPush()
        return true
    }

    func registerForPush() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
            if let error = error {
                NSLog("Error while requesting notification permissions: \(error.localizedDescription)")
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }

    static func closeSessionAPINotification() {
        let content = UNMutableNotificationContent()
        content.title = "Close Helpshift Support Session API"
        content.body = "This is a push notification to close Helpshift Session."
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: AppDelegate.closeSession, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending push notification: \(error.localizedDescription)")
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let stringToken = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        AppData.savePushToken(stringToken)
        Helpshift.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications! Error : \(error.localizedDescription)")
    }

    private func installConfig() -> [String: Any] {
        let config = ["enableLogging": true]
        return config
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        if let origin = userInfo["origin"] as? String, origin == "helpshift" {
            print("userNotificationCenter:willPresentNotification for helpshift origin.")
            Helpshift.handleNotification(withUserInfoDictionary:userInfo, isAppLaunch: false)
            return []
        }
        return [.banner, .sound, .list]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        if let origin = userInfo["origin"] as? String, origin == "helpshift" {
            print("userNotificationCenter:didReceiveResponse for helpshift origin.")
            Helpshift.handleNotification(withUserInfoDictionary:userInfo, isAppLaunch: true)
        } else if let proactiveLink = userInfo["helpshift_proactive_link"] as? String {
            Helpshift.handleProactiveLink(proactiveLink)
        } else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            let identifier = response.notification.request.identifier
            //The received notification's identifier must match the one set
            if identifier == AppDelegate.closeSession {
                // Perform closeSession method when the user taps on the notification
                Helpshift.closeSession()
            }
        } else {
            print("userNotificationCenter:didReceiveResponse for the client notification")
        }
    }
}

extension AppDelegate: HelpshiftDelegate {
    func handleHelpshiftEvent(_ eventName: String, withData data: [AnyHashable : Any]?) {
        EventManager.shared.handleEvent(eventName, withData: data)
    }

    func authenticationFailedForUser(with reason: HelpshiftAuthenticationFailureReason) {
        let reasonString = {
            switch reason {
            case .authTokenNotProvided: return "Auth token not provided"
            case .invalidAuthToken: return "Invalid auth token"
            @unknown default: return "Unknown"
            }
        }()
        print("Helpshift user authentication failed. Reason: \(reasonString)")
    }
}

extension AppDelegate: HelpshiftProactiveAPIConfigCollectorDelegate {
    func getAPIConfig() -> [AnyHashable : Any] {
        return ["firstUserMessage": "Hi there!",
                "fullPrivacy": true,
                "contactUsVisibility": 1,
                "tags": ["vip", "payment", "blocked", "renewal"],
                "customMetadata": ["vip": "yes",
                                   "level": "7",
                                   "user": "paid",
                                   "score": "12"],
                "cifs": ["joining_date": ["type": "date", "value": 1685946802123] as [String : Any],
                         "stock_level": ["type": "number", "value": "1034"],
                         "employee_name": ["type": "singleline", "value":"Proactive User"]]]
    }
}

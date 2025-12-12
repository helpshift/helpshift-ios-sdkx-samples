import Foundation
import UserNotifications
import UIKit
import HelpshiftX

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {

    static let closeSession = "closeSessionNotification"

    func registerForPush() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge,.alert,.sound]) { granted, error in
            if granted {
                print("Notification auth granted, registering for remote notifications")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification auth denied")
            }
        }
    }

    @MainActor
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        if let origin = userInfo["origin"] as? String, origin == "helpshift" {
            print("userNotificationCenter:willPresentNotification: for helpshift origin.")

            return await Helpshift.handleForegroundNotification(userInfo)
        }
        return [.banner, .sound, .list]
    }

    @MainActor
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        if let origin = userInfo["origin"] as? String, origin == "helpshift" {
            print("userNotificationCenter:didReceiveResponse: for helpshift origin.")

            await Helpshift.handleBackgroundNotificationClick(userInfo)
        } else if let proactiveLink = userInfo["helpshift_proactive_link"] as? String {
            Helpshift.handleProactiveLink(proactiveLink)
        } else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            let identifier = response.notification.request.identifier
            //The received notification's identifier must match the one set
            if identifier == NotificationHandler.closeSession {
                // Perform closeSession method when the user taps on the notification
                Helpshift.closeSession()
            }
        } else {
            print("userNotificationCenter:didReceiveResponse: for the client notification")
        }
    }

    func handleRegister(deviceToken: Data) {
        let stringToken = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        AppData.savePushToken(stringToken)
        Helpshift.registerDeviceToken(deviceToken)
    }

    func handleRegisterFail(error: Error) {
        print("Failed to register for remote notifications! Error : \(error.localizedDescription)")
    }

    @MainActor
    func handleRemoteNotification(_ userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        let origin = userInfo["origin"] as? String
        if origin == "helpshift" {
            print("application:didReceiveRemoteNotification: for helpshift origin.")
            return await Helpshift.handleSilentBackgroundNotification(userInfo)
        }
        return .noData
    }

    static func closeSessionAPINotification() {
        let content = UNMutableNotificationContent()
        content.title = "Close Helpshift Support Session API"
        content.body = "This is a push notification to close Helpshift Session."
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: NotificationHandler.closeSession, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending push notification: \(error.localizedDescription)")
            }
        }
    }
}

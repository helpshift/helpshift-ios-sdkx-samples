//
//  FalconNotificationService.swift
//  FalconNSExtension
//
//  Created by Joyson P S on 01/09/25.
//  Copyright © 2025 Helpshift. All rights reserved.
//

import UserNotifications
import HelpshiftX

class FalconNotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var originalContent: UNNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        self.originalContent = request.content

        let origin = request.content.userInfo["origin"] as? String
        if origin == "helpshift" {
            Helpshift.handleBackgroundNotification(request, withContentHandler: contentHandler)
        } else {
            contentHandler(request.content)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content,
        // otherwise the original push payload will be used.
        if let contentHandler, let originalContent {
            contentHandler(originalContent)
        }
    }

}

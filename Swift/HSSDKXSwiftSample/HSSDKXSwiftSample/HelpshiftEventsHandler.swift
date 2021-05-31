//
//  HelpshiftEventsHandler.swift
//  HSSDKXSwiftSample
//
//  Created by Sagar Dagdu on 28/05/21.
//  Copyright © 2021 Sagar Dagdu. All rights reserved.
//

import UIKit
import HelpshiftX

final class HelpshiftEventsHandler: NSObject, HelpshiftDelegate {
    
    static let shared = HelpshiftEventsHandler()
    
    private override init() {
        
    }
    
    func handleHelpshiftEvent(_ eventName: String, withData data: [AnyHashable : Any]?) {
        //TODO: Handle events from HelpshiftX SDK here.
        let eventData = data ?? [AnyHashable:Any]()
        print("Helpshift Event: \(eventName), event data: \(eventData)")
    }
    
    func authenticationFailedForUser(with reason: HelpshiftAuthenticationFailureReason) {
        //TODO: Handle authentication failed.
        print("Helpshift: Failed to authenticate user, reason: \(reason)")
    }
    
    
}

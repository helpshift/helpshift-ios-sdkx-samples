//
//  UIUtils.swift
//  HSSDKSwiftUISample
//
//  Created by Sagar Dagdu on 28/05/21.
//

import UIKit

final class UIUtils {
    private init() {
        
    }
    
    static func rootViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter(\.isKeyWindow).first
        if let rootController = keyWindow?.rootViewController {
            return rootController
        }
        
        return nil
    }
    
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter(\.isKeyWindow).first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
    }
}

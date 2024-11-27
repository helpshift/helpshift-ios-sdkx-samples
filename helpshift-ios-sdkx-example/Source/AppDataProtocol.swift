//
//  AppData.swift
//  Copyright © 2023 Helpshift. All rights reserved.
//

import Foundation

protocol AppDataProtocol {
    static var domain: String { get }
    static var platformId: String { get }
    static var webchatUrl: String { get }
    static var helpcenterUrl: String { get }
    static var helpcenterSandbox: Bool { get }
    static var webviewInspectable: Bool { get }
    static func saveDomain(_ domain: String)
    static func savePlatformId(_ id: String)
    static func saveWebchatUrl(_ url: String)
    static func saveHelpcenterUrl(_ url: String)
    static func saveHelpcenterSandbox(_ sandbox: Bool)
    static func saveWebviewInspectable(_ inspectable: Bool)
    static func applyToSdk()
    static func saveIdentityJWTToken(_ jwtToken: String)
    static func saveIdentityLoginData(_ data: String)
    static func saveIdentitesJson(_ json: String)
    static func saveSecretKey(_ secretKey: String)

    static var secretKey: String { get }
    static var identitiesJson: String { get }
    static var identityJwtToken: String { get }
    static var identityLoggedInData: String { get }

}

extension AppDataProtocol {
    static var sdkInstallCreds: [String: Any] {
        guard let sdkInstallCredsPath = Bundle.main.url(forResource: "sdk_install_creds", withExtension: "plist") else {
            fatalError("sdk_install_creds.plist file not found!")
        }
        guard let sdkInstallCredsData = try? Data(contentsOf: sdkInstallCredsPath) else {
            fatalError("sdk_install_creds.plist does not contain valid data!")
        }
        guard let dict = try? PropertyListSerialization.propertyList(from: sdkInstallCredsData, options: [], format: nil) as? [String: Any] else {
            fatalError("sdk_install_creds.plist data not in valid format!")
        }
        return dict
    }

    static var language: String {
        UserDefaults.standard.string(forKey: Constants.Storage.hsLanguageKey) ?? ""
    }

    static func saveLanguage(_ language: String) {
        UserDefaults.standard.set(language.trimmed, forKey: Constants.Storage.hsLanguageKey)
    }

    static var pushToken: String {
        UserDefaults.standard.string(forKey: Constants.Storage.hsPushTokenKey) ?? ""
    }

    static func savePushToken(_ pushToken: String) {
        UserDefaults.standard.set(pushToken.trimmed, forKey: Constants.Storage.hsPushTokenKey)
    }
}

struct DemoAppData: AppDataProtocol {
    static var domain = sdkInstallCreds[Constants.Storage.hsDomainkey] as? String ?? ""
    static var platformId = sdkInstallCreds[Constants.Storage.hsPlatformIdKey] as? String ?? ""
    static var webchatUrl = ""
    static var helpcenterUrl = ""
    static var helpcenterSandbox = false
    static var webviewInspectable = true
    static func saveDomain(_ domain: String) {}
    static func savePlatformId(_ id: String) {}
    static func saveWebchatUrl(_ url: String) {}
    static func saveHelpcenterUrl(_ url: String) {}
    static func saveHelpcenterSandbox(_ sandbox: Bool) {}
    static func saveWebviewInspectable(_ inspectable: Bool) {}
    static func applyToSdk() {}
    static func saveIdentityJWTToken(_ jwtToken: String) {}
    static func saveIdentityLoginData(_ data: String) {}
    static func saveIdentitesJson(_ json: String) {}
    static func saveSecretKey(_ secretKey: String) {}
    static var secretKey = ""
    static var identitiesJson = ""
    static var identityJwtToken = ""
    static var identityLoggedInData = ""
}

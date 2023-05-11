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
    static var language: String { get }
    static func saveDomain(_ domain: String)
    static func savePlatformId(_ id: String)
    static func saveWebchatUrl(_ url: String)
    static func saveHelpcenterUrl(_ url: String)
    static func saveHelpcenterSandbox(_ sandbox: Bool)
    static func saveLanguage(_ language: String)
    static func applyToSdk()
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
}

struct DemoAppData: AppDataProtocol {
    static var domain = sdkInstallCreds[Constants.Storage.hsDomainkey] as? String ?? ""
    static var platformId = sdkInstallCreds[Constants.Storage.hsPlatformIdKey] as? String ?? ""
    static var webchatUrl = ""
    static var helpcenterUrl = ""
    static var helpcenterSandbox = false
    static func saveDomain(_ domain: String) {}
    static func savePlatformId(_ id: String) {}
    static func saveWebchatUrl(_ url: String) {}
    static func saveHelpcenterUrl(_ url: String) {}
    static func saveHelpcenterSandbox(_ sandbox: Bool) {}
    static func applyToSdk() {}
}

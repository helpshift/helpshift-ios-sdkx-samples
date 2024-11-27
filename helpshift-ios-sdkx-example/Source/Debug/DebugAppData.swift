//
//  DebugAppSdkValues.swift
//  Copyright © 2023 Helpshift. All rights reserved.
//

import Foundation

struct DebugAppData: AppDataProtocol {

    static var domain: String {
        if let domain = UserDefaults.standard.string(forKey: Constants.Storage.hsDomainkey),
           !domain.isBlank {
            return domain
        } else {
            return sdkInstallCreds[Constants.Storage.hsDomainkey] as? String ?? ""
        }
    }

    static var platformId: String {
        if let platformId = UserDefaults.standard.string(forKey: Constants.Storage.hsPlatformIdKey),
           !platformId.isBlank {
            return platformId
        } else {
            return sdkInstallCreds[Constants.Storage.hsPlatformIdKey] as? String ?? ""
        }
    }

    static var webchatUrl: String {
        if let webchatUrl = UserDefaults.standard.string(forKey: Constants.Storage.hsWebchatUrlKey),
           !webchatUrl.isBlank {
            return webchatUrl
        } else {
            return sdkWebchatUrl
        }
    }

    static var helpcenterUrl: String {
        if let helpcenterUrl = UserDefaults.standard.string(forKey: Constants.Storage.hsHelpcenterUrlKey),
           !helpcenterUrl.isBlank {
            return helpcenterUrl
        } else {
            return sdkHelpcenterUrl
        }
    }

    static var identityJwtToken: String {
        if let token = UserDefaults.standard.string(forKey: Constants.Storage.hsIdentitiesJwtToken) {
            return token
        }
        return ""
    }

    static var identityLoggedInData: String {
        if let loggedInData = UserDefaults.standard.string(forKey: Constants.Storage.hsIdentitiesLoginData) {
            return loggedInData
        }
        return ""
    }

    static var identitiesJson: String {
        if let identityJson = UserDefaults.standard.string(forKey: Constants.Storage.hsIdentitiesJson) {
            return identityJson
        }
        return ""
    }

    static var secretKey: String {
        if let secretKey = UserDefaults.standard.string(forKey: Constants.Storage.hsSecretKey) {
            return secretKey
        }
        return ""
    }

    static var helpcenterSandbox: Bool {
        UserDefaults.standard.bool(forKey: Constants.Storage.hsHelpcenterSandboxKey)
    }

    static var webviewInspectable: Bool {
        UserDefaults.standard.bool(forKey: Constants.Storage.hsWebviewInspectableKey)
    }

    static func saveDomain(_ domain: String) {
        UserDefaults.standard.set(domain.trimmed, forKey: Constants.Storage.hsDomainkey)
    }

    static func savePlatformId(_ id: String) {
        UserDefaults.standard.set(id.trimmed, forKey: Constants.Storage.hsPlatformIdKey)
    }

    static func saveWebchatUrl(_ url: String) {
        UserDefaults.standard.set(url.trimmed, forKey: Constants.Storage.hsWebchatUrlKey)
    }

    static func saveHelpcenterUrl(_ url: String) {
        UserDefaults.standard.set(url.trimmed, forKey: Constants.Storage.hsHelpcenterUrlKey)
    }

    static func saveHelpcenterSandbox(_ sandbox: Bool) {
        UserDefaults.standard.set(sandbox, forKey: Constants.Storage.hsHelpcenterSandboxKey)
    }

    static func saveWebviewInspectable(_ inspectable: Bool) {
        UserDefaults.standard.set(inspectable, forKey: Constants.Storage.hsWebviewInspectableKey)
    }

    static func saveIdentityJWTToken(_ jwtToken: String) {
        UserDefaults.standard.set(jwtToken, forKey: Constants.Storage.hsIdentitiesJwtToken)
    }

    static func saveIdentityLoginData(_ data: String) {
        UserDefaults.standard.set(data, forKey: Constants.Storage.hsIdentitiesLoginData)
    }

    static func saveIdentitesJson(_ json: String) {
        UserDefaults.standard.set(json, forKey: Constants.Storage.hsIdentitiesJson)
    }

    static func saveSecretKey(_ secretKey: String) {
        UserDefaults.standard.set(secretKey, forKey: Constants.Storage.hsSecretKey)
    }

    private static var sdkWebchatUrl: String {
        guard let clazz = NSClassFromString("HsUrlUtils") as? NSObject.Type else {
            fatalError("HsUrlUtils class not found in SDK!")
        }
        let sel = Selector(("webchatMiddlewareUrl"))
        guard let url = clazz.perform(sel).takeUnretainedValue() as? String else {
            fatalError("HsUrlUtils.webchatMiddlewareUrl does not return a valid URL!")
        }
        return url
    }

    private static var sdkHelpcenterUrl: String {
        guard let clazz = NSClassFromString("HsUrlUtils") as? NSObject.Type else {
            fatalError("HsUrlUtils class not found in SDK!")
        }
        let sel = Selector(("helpcenterMiddlewareUrl"))
        guard let url = clazz.perform(sel).takeUnretainedValue() as? String else {
            fatalError("HsUrlUtils.helpcenterMiddlewareUrl does not return a valid URL!")
        }
        return url
    }

    static func applyToSdk() {
        if !SwizzledMethods.swizzled_webchatMiddlewareUrl().isBlank {
            swizzle(classMethod: "webchatMiddlewareUrl",
                    inClass: "HsUrlUtils",
                    with: #selector(SwizzledMethods.swizzled_webchatMiddlewareUrl))
        }
        if !SwizzledMethods.swizzled_helpcenterMiddlewareUrl().isBlank {
            swizzle(classMethod: "helpcenterMiddlewareUrl",
                    inClass: "HsUrlUtils",
                    with: #selector(SwizzledMethods.swizzled_helpcenterMiddlewareUrl))
        }
        swizzle(classMethod: "isSandbox",
                inClass: "HsConstants",
                with: #selector((SwizzledMethods.swizzled_isSandbox)))
    }

    private static func swizzle(classMethod classMethodString: String,
                                inClass classString: String,
                                with selector: Selector) {
        let originalClass: AnyClass? = NSClassFromString(classString)
        let originalSelector = NSSelectorFromString(classMethodString)
        let originalMethod = class_getClassMethod(originalClass, originalSelector)
        let swizzledMethod = class_getClassMethod(SwizzledMethods.self, selector)
        guard let originalMethod = originalMethod, let swizzledMethod = swizzledMethod else {
            fatalError("Cannot swizzle \(classMethodString) class method in class \(classString)!")
        }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    static func purgeData() {
        let fm = FileManager.default
        // Delete all data from data container.
        var urls = [URL]()
        urls.append(contentsOf: fm.urls(for: .libraryDirectory, in: .userDomainMask))
        urls.append(contentsOf: fm.urls(for: .documentDirectory, in: .userDomainMask))
        for url in urls {
            do {
                let files = try fm.contentsOfDirectory(at: url,
                                                       includingPropertiesForKeys: nil,
                                                       options: [.skipsSubdirectoryDescendants])
                for file in files {
                    do {
                        try fm.removeItem(at: file)
                    } catch {
                        print("Could not delete file at path: \(file.absoluteString)")
                    }
                }
            } catch {
                print("Could not access directory at path: \(url.absoluteString)")
            }
        }

        // Delete all data from keychain.
        let deleteAllKeysForSecClass: (CFTypeRef) -> Bool = { secClass in
            let query: [String: Any] = [kSecClass as String: secClass]
            let result = SecItemDelete(query as CFDictionary)
            return result == noErr || result == errSecItemNotFound
        }
        let _ = deleteAllKeysForSecClass(kSecClassInternetPassword)
        let _ = deleteAllKeysForSecClass(kSecClassGenericPassword)
        let _ = deleteAllKeysForSecClass(kSecClassCertificate)
        let _ = deleteAllKeysForSecClass(kSecClassKey)
        let _ = deleteAllKeysForSecClass(kSecClassIdentity)

        exit(0)
    }
}

// Holder for swizzled versions of SDK URL methods.
fileprivate class SwizzledMethods: NSObject {
    @objc static func swizzled_webchatMiddlewareUrl() -> String {
        return UserDefaults.standard.string(forKey: Constants.Storage.hsWebchatUrlKey) ?? ""
    }

    @objc static func swizzled_helpcenterMiddlewareUrl() -> String {
        return UserDefaults.standard.string(forKey: Constants.Storage.hsHelpcenterUrlKey) ?? ""
    }

    @objc static func swizzled_isSandbox() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.Storage.hsHelpcenterSandboxKey)
    }
}

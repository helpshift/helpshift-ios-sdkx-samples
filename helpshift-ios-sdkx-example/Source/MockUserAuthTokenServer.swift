//
//  MockUserAuthTokenServer.swift
//  Copyright © 2023 Helpshift. All rights reserved.
//

import Foundation
import CryptoKit

/**
 * A mock function to generate user authentication token.
 * This logic/code should be a backend service and should NOT be included in the app's code.
 * The secret key should reside on your backend so that it is secure and can be rotated whenever needed.
 */
struct MockUserAuthTokenServer {

    static func generateHMAC(_ id: String, _ email: String, _ key: String) -> String {
        guard let messageData = (id + email).data(using: .utf8) else { return "" }
        guard let keyData = key.data(using: .utf8) else { return "" }
        let hmac = HMAC<SHA256>.authenticationCode(for: messageData, using: SymmetricKey(data: keyData))
        let base64hmac = Data(hmac).base64EncodedString()
        print("DBG \(base64hmac)")
        return base64hmac
    }
}

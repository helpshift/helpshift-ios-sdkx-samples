//
//  Util.swift
//  Falcon
//
//  Created by Joyson P S on 25/10/24.
//  Copyright © 2024 Helpshift. All rights reserved.
//

import Foundation
import SwiftJWT

class Util {
    static func generateJWT(iat: Int?, identities: [UserIdentity], secretKey: String) -> String? {
        let header = Header()
        let iat = iat ?? Int(Date().timeIntervalSince1970)
        let claims = UserIdentitiesClaims(identities: identities, iat: iat)
        var jwt = JWT(header: header, claims: claims)
        guard let secretKeyData = secretKey.data(using: .utf8) else {
            print("Error: Failed to convert secret key to data.")
            return nil
        }
        let jwtSigner = JWTSigner.hs256(key: secretKeyData)
        do {
            let signedJWT = try jwt.sign(using: jwtSigner)
            return signedJWT
        } catch {
            print("Error signing JWT: \(error)")
            return nil
        }
    }

    static func decode<T: Decodable>(from array: [[String: Any]]) throws -> [T] {
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        let decodedObjects = try JSONDecoder().decode([T].self, from: data)
        return decodedObjects
    }

    static func prettyPrintedJSON<T: Encodable>(from value: T) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let jsonData = try encoder.encode(value)
            return String(data: jsonData, encoding: .utf8) ?? "{ \"error\": \"Failed to encode JSON string.\" }"
        } catch {
            return "{ \"error\": \"\(error.localizedDescription)\" }"
        }
    }

    static func format(_ date: Date?) -> String {
        guard let date = date else { return "--" }
        return dateFormatter.string(from: date)
    }

    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss.SSS"
        return formatter
    }()
}

//
//  UserIdentityModel.swift
//  Falcon
//
//  Created by Arif Ashraf on 01/10/24.
//  Copyright © 2024 Helpshift. All rights reserved.
//

import Foundation
import SwiftJWT

struct UserIdentity: Claims {
    var identifierKey: String = ""
    var identifierValue: String = ""
    var valueKey: String = ""
    var identityValue: String = ""
    var metadata: [String: String]?

    enum CodingKeys: String, CodingKey {
        case identifierKey = "identifier"
        case valueKey = "value"
        case metadata
    }

    init(identifierKey: String = "",
         identifierValue: String = "",
         valueKey: String = "",
         identityValue: String = "",
         metadata: [String: String]? = nil) {
        self.identifierKey = identifierKey
        self.identifierValue = identifierValue
        self.valueKey = valueKey
        self.identityValue = identityValue
        self.metadata = metadata
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifierValue = try container.decode(String.self, forKey: .identifierKey)
        self.identityValue = try container.decode(String.self, forKey: .valueKey)
        self.metadata = try container.decodeIfPresent([String: String].self, forKey: .metadata)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifierValue, forKey: .identifierKey)
        try container.encode(identityValue, forKey: .valueKey)
        if let metadata = metadata {
            try container.encode(metadata, forKey: .metadata)
        }
    }
}

struct UserIdentitiesClaims: Claims {
    let identities: [UserIdentity]
    let iat: Int?
}

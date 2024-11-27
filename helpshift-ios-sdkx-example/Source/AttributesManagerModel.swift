//
//  AttributesManagerModel.swift
//  Falcon
//
//  Created by Arif Ashraf on 09/10/24.
//  Copyright © 2024 Helpshift. All rights reserved.
//

import Foundation
import HelpshiftX

enum AttributeType {
    case master
    case app
}

struct AttributesManager {
    var attributes: [String: Any] = [:]
    var attributeKey: String = ""
    var attributeValue: String = ""
    var cuf: [String: String] = [:]
    var cufKey: String = ""
    var cufValue: String = ""
    var attributesJSON: String = "{}"

    mutating func addAttribute() {
        let key = attributeKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let value = attributeValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if !key.isEmpty && !value.isEmpty {
            attributes[key] = parseValue(value)
            attributeKey = ""
            attributeValue = ""
            updateAttributesJSON()
        }
    }

    mutating func addCuf() {
        let key = cufKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let value = cufValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if !key.isEmpty && !value.isEmpty {
            cuf[key] = value
            attributes["custom_user_fields"] = cuf
            cufKey = ""
            cufValue = ""
            updateAttributesJSON()
        }
    }

    mutating func updateAttributes(type: AttributeType) {
        switch type {
        case .master:
            Helpshift.updateMasterAttributes(attributes)
        case .app:
            Helpshift.updateAppAttributes(attributes)
        }
        // Reset attributes
        attributes = [:]
        cuf = [:]
        attributesJSON = "{}"
    }

    private mutating func updateAttributesJSON() {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: attributes, options: [.prettyPrinted])
            attributesJSON = String(data: jsonData, encoding: .utf8) ?? "Error converting JSON data to string"
        } catch {
            attributesJSON = "Error generating JSON: \(error)"
        }
    }

    private func parseValue(_ value: String) -> Any {
        if value.lowercased() == "true" {
            return true
        } else if value.lowercased() == "false" {
            return false
        } else if value.contains(",") {
            return value.components(separatedBy: ",")
        }
        return value
    }
}

//
//  Extensions.swift
//  Copyright © 2023 Helpshift. All rights reserved.
//

import Foundation

extension String {
    var trimmed: Self {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isBlank: Bool {
        self.trimmed.isEmpty
    }

    var toDictionary: [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return dictionary
        } catch {
            print("Error converting string to dictionary: \(error)")
            return nil
        }
    }
}

extension Dictionary {
    // Convert Dictionary to JSON string
    func toJSONString() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Error converting dictionary to string: \(error)")
            return nil
        }
    }
}

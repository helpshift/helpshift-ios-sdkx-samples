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

extension URLRequest {
    /// Returns the request body as a String, handling both httpBody and httpBodyStream
    func bodyAsString() -> String? {
        if let bodyData = self.httpBody {
            return String(data: bodyData, encoding: .utf8)
        } else if let stream = self.httpBodyStream {
            stream.open()
            defer { stream.close() }
            let bufferSize = 1024
            var buffer = [UInt8](repeating: 0, count: bufferSize)
            var data = Data()
            while stream.hasBytesAvailable {
                let read = stream.read(&buffer, maxLength: bufferSize)
                if read > 0 {
                    data.append(buffer, count: read)
                } else {
                    break
                }
            }
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
}

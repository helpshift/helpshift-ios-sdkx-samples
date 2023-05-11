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
}

//
//  String+removingTrailingPunctuation.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 30.09.2025.
//

import Foundation

// MARK: - String helpers

public extension String {
	func removingTrailingPunctuation() -> String {
		return self.replacingOccurrences(
			of: #"[[:punct:]\s\u{00A0}]+$"#,
			with: "",
			options: .regularExpression
		).trimmingCharacters(in: .whitespacesAndNewlines)
	}
}

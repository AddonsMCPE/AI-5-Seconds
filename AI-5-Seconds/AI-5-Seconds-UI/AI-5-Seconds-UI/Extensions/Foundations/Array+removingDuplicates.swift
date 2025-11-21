//
//  Array+removingDuplicates.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 10.10.2025.
//

import Foundation

public extension Array where Element == String {
	func removingDuplicates(
		caseInsensitive: Bool = false,
		diacriticInsensitive: Bool = false,
		trimWhitespace: Bool = false
	) -> [String] {
		var seen = Set<String>()
		var result: [String] = []
		
		for original in self {
			var key = original
			if trimWhitespace {
				key = key.trimmingCharacters(in: .whitespacesAndNewlines)
			}
			if caseInsensitive || diacriticInsensitive {
				var opts: String.CompareOptions = []
				if caseInsensitive { opts.insert(.caseInsensitive) }
				if diacriticInsensitive { opts.insert(.diacriticInsensitive) }
				key = key.folding(options: opts, locale: .current)
			}
			if seen.insert(key).inserted {
				result.append(original)
			}
		}
		return result
	}
}

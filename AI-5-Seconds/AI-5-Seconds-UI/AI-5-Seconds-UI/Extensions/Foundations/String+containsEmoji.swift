//
//  String+containsEmoji.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 10.10.2025.
//

import Foundation

private extension Character {
	var isEmoji: Bool {
		if unicodeScalars.contains(where: { $0.properties.isEmojiPresentation }) { return true }
		let scalars = unicodeScalars
		return scalars.contains(where: { $0.properties.isEmoji }) &&
		!scalars.allSatisfy { $0.properties.isVariationSelector }
	}
}

public extension String {
	var containsEmoji: Bool { contains { $0.isEmoji } }
	
	var isOnlyEmoji: Bool {
		trimmingCharacters(in: .whitespacesAndNewlines)
			.allSatisfy { $0.isEmoji }
		&& !isEmpty
	}
}

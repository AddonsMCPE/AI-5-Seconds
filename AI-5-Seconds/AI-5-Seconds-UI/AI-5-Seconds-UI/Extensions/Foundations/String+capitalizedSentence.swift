//
//  String+capitalizedSentence.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 11.08.2024.
//

import Foundation

public extension String {
	var capitalizedSentence: String {
		let firstLetter = self.prefix(1).capitalized
		let remainingLetters = self.dropFirst().lowercased()
		return firstLetter + remainingLetters
	}
}

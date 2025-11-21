//
//  String+likeHtmlAttributedString.swift
//  IA_Minecraft-UI
//
//  Created by Anna Radchenko on 09.03.2025.
//

import UIKit

public extension String {
	func likeHtmlAttributedString(
		highlightColor: UIColor = .textPrimary,
		highlightFontName: UIFont = .extrabold16
	) -> NSMutableAttributedString {
		let attributedString = NSMutableAttributedString()
		let regex = try! NSRegularExpression(pattern: "<b>(.*?)</b>", options: [])
		
		let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
		
		var lastMatchEndIndex = self.startIndex
		
		for match in matches {
			if let range = Range(match.range, in: self),
				 let boldRange = Range(match.range(at: 1), in: self) {
				
				if range.lowerBound > lastMatchEndIndex {
					let plainText = String(self[lastMatchEndIndex..<range.lowerBound])
					attributedString.append(NSAttributedString(string: plainText))
				}
				
				let boldText = String(self[boldRange])
				let attributes: [NSAttributedString.Key: Any] = [
					.foregroundColor: highlightColor,
					.font: highlightFontName
				]
				let boldAttributedString = NSAttributedString(string: boldText, attributes: attributes)
				attributedString.append(boldAttributedString)
				
				lastMatchEndIndex = range.upperBound
			}
		}
		
		if lastMatchEndIndex < self.endIndex {
			let remainingText = String(self[lastMatchEndIndex..<self.endIndex])
			attributedString.append(NSAttributedString(string: remainingText))
		}
		
		return attributedString
	}
}

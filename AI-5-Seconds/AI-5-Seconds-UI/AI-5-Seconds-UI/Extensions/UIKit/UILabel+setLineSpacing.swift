//
//  UILabel+setLineSpacing.swift
//  IA_Minecraft-UI
//
//  Created by Anna Radchenko on 09.03.2025.
//

import UIKit

public extension UILabel {
	func setLineSpacing(lineSpacing: CGFloat) {
		guard let text = self.text else { return }
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = lineSpacing
		paragraphStyle.alignment = self.textAlignment
		
		let attributedString: NSMutableAttributedString
		if let existingAttributedText = self.attributedText {
			attributedString = NSMutableAttributedString(attributedString: existingAttributedText)
		} else {
			attributedString = NSMutableAttributedString(string: text)
		}
		
		attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
		self.attributedText = attributedString
	}
}

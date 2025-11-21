//
//  UILable+setTextWithBorder.swift
//  IA_Minecraft-UI
//
//  Created by Anna Radchenko on 10.09.2025.
//

import UIKit

public extension UILabel {
	func setTextWithBorder(
		_ text: String,
		textColor: UIColor = .colorWhite,
		borderColor: UIColor = .colorBlack,
		borderWidth: CGFloat = 2.0,
		font: UIFont? = nil
	) {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: textColor,
			.strokeColor: borderColor,
			.strokeWidth: -borderWidth,
			.font: font ?? self.font as Any
		]
		self.attributedText = NSAttributedString(string: text, attributes: attributes)
	}
}

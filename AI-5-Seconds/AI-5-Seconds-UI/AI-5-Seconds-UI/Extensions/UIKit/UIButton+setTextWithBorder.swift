//
//  UIButton+setTextWithBorder.swift
//  IA_Minecraft-UI
//
//  Created by Anna Radchenko on 10.09.2025.
//

import UIKit

public extension UIButton {
	func setTitleWithBorder(
		_ text: String,
		textColor: UIColor = .colorWhite,
		borderColor: UIColor = .colorBlack,
		borderWidth: CGFloat = 2.0,
		font: UIFont? = nil,
		for state: UIControl.State = .normal
	) {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: textColor,
			.strokeColor: borderColor,
			.strokeWidth: -borderWidth,
			.font: font ?? self.titleLabel?.font as Any
		]
		
		let attributedString = NSAttributedString(string: text, attributes: attributes)
		self.setAttributedTitle(attributedString, for: state)
	}
}

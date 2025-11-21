//
//  UILabel+Style.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 17.04.2023.
//

import UIKit

public extension UILabel {
	func setStyle(
		textColor: UIColor = .textPrimary,
		font: UIFont = .medium16,
		numberOfLines: Int = 1,
		textAlignment: NSTextAlignment = .left,
		isScaleEnabled: Bool = true
	) {
		self.textColor = textColor
		self.font = font
		self.numberOfLines = numberOfLines
		adjustsFontSizeToFitWidth = isScaleEnabled
		minimumScaleFactor = 0.5
		self.textAlignment = textAlignment
	}
}

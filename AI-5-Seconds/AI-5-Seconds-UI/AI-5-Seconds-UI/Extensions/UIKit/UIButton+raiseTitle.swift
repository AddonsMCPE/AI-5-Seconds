//
//  UIButton+raiseTitle.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 23.09.2025.
//

import UIKit

public extension UIButton {
	func raiseTitle(by dy: CGFloat = 3) {
		titleEdgeInsets = UIEdgeInsets(
			top: titleEdgeInsets.top - dy,
			left: titleEdgeInsets.left,
			bottom: titleEdgeInsets.bottom + dy,
			right: titleEdgeInsets.right
		)
	}
	
	func raiseImage(by dy: CGFloat = 3) {
		imageEdgeInsets = UIEdgeInsets(
			top: titleEdgeInsets.top - dy,
			left: titleEdgeInsets.left,
			bottom: titleEdgeInsets.bottom + dy,
			right: titleEdgeInsets.right
		)
	}
}

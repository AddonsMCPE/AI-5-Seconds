//
//  UIView+Shadow.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 18.04.2023.
//

import UIKit

public extension UIView {
	func shadowInstall(
		for view: UIView,
		shadowColor: CGColor = UIColor.black.withAlphaComponent(0.5).cgColor,
		shadowOpacity: Float = 1,
		shadowOffset: CGSize = CGSize(width: 4, height: 4),
		shadowRadius: CGFloat = 4
	) {
		view.layer.shadowOpacity = shadowOpacity
		view.layer.shadowOffset = shadowOffset
		view.layer.shadowRadius = shadowRadius
		view.layer.shadowColor = shadowColor
		view.layer.masksToBounds = false
	}
}

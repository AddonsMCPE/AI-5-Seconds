//
//  UIView+roundCorners.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 10.10.2025.
//

import UIKit

public extension UIView {
	func roundCorners(corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		layer.mask = mask
	}
}

//
//  UILabel+applyGlowShadow.swift
//  IA_Minecraft-UI
//
//  Created by Anna Radchenko on 10.09.2025.
//

import UIKit

public extension UILabel {
	func applyGlowShadow(
		color: UIColor = .colorBlack,
		radius: CGFloat = 0,
		opacity: Float = 1
	) {
		self.shadowColor = nil
		self.shadowOffset = .zero
		
		self.layer.shadowColor = color.cgColor
		self.layer.shadowOffset = .zero
		self.layer.shadowRadius = radius
		self.layer.shadowOpacity = opacity
		self.layer.masksToBounds = false
	}
}

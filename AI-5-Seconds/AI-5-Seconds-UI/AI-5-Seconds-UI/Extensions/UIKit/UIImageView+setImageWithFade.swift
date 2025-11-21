//
//  UIImageView+setImageWithFade.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 27.09.2025.
//

import UIKit

public extension UIImageView {
	func setImageWithFade(
		_ newImage: UIImage?,
		duration: TimeInterval = 0.3,
		options: UIView.AnimationOptions = [.transitionCrossDissolve, .allowUserInteraction]
	) {
		if Thread.isMainThread {
			UIView.transition(with: self, duration: duration, options: options, animations: {
				self.image = newImage
			}, completion: nil)
		} else {
			DispatchQueue.main.async {
				UIView.transition(with: self, duration: duration, options: options, animations: {
					self.image = newImage
				}, completion: nil)
			}
		}
	}
}

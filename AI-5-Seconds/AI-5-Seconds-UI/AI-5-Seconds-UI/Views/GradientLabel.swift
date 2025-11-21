//
//	GradientLabel.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 13.09.2022.
//

import UIKit

public final class GradientLabel: UILabel {
	public var gradientColors: [CGColor] = []

	public override func drawText(in rect: CGRect) {
		if let gradientColor = drawGradientColor(in: rect, colors: gradientColors) {
			self.textColor = gradientColor
		}
		super.drawText(in: rect)
	}

	private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
		let currentContext = UIGraphicsGetCurrentContext()
		currentContext?.saveGState()
		defer { currentContext?.restoreGState() }

		let size = rect.size
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
																		colors: colors as CFArray,
																		locations: nil) else { return nil }

		let context = UIGraphicsGetCurrentContext()
		context?.drawLinearGradient(gradient,
																start: CGPoint.zero,
																end: CGPoint(x: size.width, y: 0),
																options: [])
		let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		guard let image = gradientImage else { return nil }
		return UIColor(patternImage: image)
	}
}

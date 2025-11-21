//
//	UIImage+FillColor.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 20.08.2022.
//

import UIKit

public extension UIImage {
	class func image(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
		return UIGraphicsImageRenderer(size: size).image { rendererContext in
			color.setFill()
			rendererContext.fill(CGRect(origin: .zero, size: size))
		}
	}
}

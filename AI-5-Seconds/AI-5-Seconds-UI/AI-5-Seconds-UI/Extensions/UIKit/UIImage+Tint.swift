//
//	UIImage+Tint.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 13.09.2022.
//

import UIKit

public extension UIImage {
	func tint(tintColor: UIColor) -> UIImage {
		return modifiedImage { context, rect in
			context.setBlendMode(.normal)
			UIColor.black.setFill()
			context.fill(rect)
			
			context.setBlendMode(.normal)
			context.draw(self.cgImage!, in: rect)
			
			context.setBlendMode(.color)
			tintColor.setFill()
			context.fill(rect)
			
			context.setBlendMode(.destinationIn)
			context.draw(self.cgImage!, in: rect)
		}
	}

	private func modifiedImage( draw: (CGContext, CGRect) -> ()) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		let context: CGContext! = UIGraphicsGetCurrentContext()
		assert(context != nil)
	
		context.translateBy(x: 0, y: size.height)
		context.scaleBy(x: 1.0, y: -1.0)
		
		let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
		
		draw(context, rect)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
}

//
//	UIImage+Crop.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 13.09.2022.
//

import UIKit

public extension UIImage {
	func cropBottomImage(part: CGFloat) -> UIImage? {
		let height = CGFloat((self.size.height * self.scale) * part)
		let rect = CGRect(x: 0, y: self.size.height * self.scale - height, width: self.size.width * self.scale, height: height)

		guard let imageRef = self.cgImage?.cropping(to: rect) else {
			return nil
		}

		let croppedImage = UIImage(cgImage:imageRef)
		return croppedImage
	}
}

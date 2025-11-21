//
//  UIImage+LoadImage.swift
//  IA_Minecraft-UI
//
//  Created by Anna Radchenko on 16.03.2025.
//

import UIKit

public extension UIImage {
	static func loadFromModsImages(named imageName: String) -> UIImage? {
		if let imagePath = Bundle.uiBundle.path(forResource: imageName, ofType: nil, inDirectory: "ModsImages") {
			return UIImage(contentsOfFile: imagePath)
		} else {
			print("Изображение не найдено: \(imageName)")
			return nil
		}
	}
}

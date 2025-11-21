//
//  UIScreen+isSmallScreen.swift
//  IA_Minecraft-UI
//
//  Created by Anna Radchenko on 09.03.2025.
//

import UIKit

public extension UIScreen {
	var isSmallScreen: Bool {
		if UIDevice.current.userInterfaceIdiom == .pad {
			return false
		}
		
		let smallScreenSizes: [(width: CGFloat, height: CGFloat)] = [
			(375, 667), // iPhone 6, 7, 8, SE2
			(414, 736), // iPhone 6+, 7+, 8+
			(320, 568)  // iPhone 5, SE (1st gen)
		]
		
		return smallScreenSizes.contains { $0.width == bounds.width && $0.height == bounds.height }
	}
}

public extension UIScreen {
	var isIpadSizeClass: Bool {
		let horizontalSizeClass = UIScreen.main.traitCollection.horizontalSizeClass
		let verticalSizeClass = UIScreen.main.traitCollection.verticalSizeClass
		return horizontalSizeClass == .regular && verticalSizeClass == .regular
	}
}

public extension UIViewController {
	var isIpadSizeClass: Bool {
		guard UIDevice.current.userInterfaceIdiom == .pad else { return false }
		
		let screenWidth = UIScreen.main.bounds.width
		let windowWidth = view.window?.bounds.width ?? screenWidth
		let isMultitasking = windowWidth < screenWidth
		
		let horizontalSizeClass = traitCollection.horizontalSizeClass
		let verticalSizeClass = traitCollection.verticalSizeClass
		
		if !isMultitasking {
			return true
		} else {
			return horizontalSizeClass == .regular && verticalSizeClass == .regular
		} 
	}
}

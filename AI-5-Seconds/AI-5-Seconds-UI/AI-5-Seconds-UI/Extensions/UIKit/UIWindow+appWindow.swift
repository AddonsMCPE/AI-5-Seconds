//
//  UIWindow+appWindow.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 16.03.2024.
//

import UIKit

public extension UIWindow {
	static var appWindow: UIWindow? {
		get {
			if #available(iOS 13.0, *) {
				return UIApplication.shared.connectedScenes
						.first { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
						.map { $0 as? UIWindowScene }
						.flatMap { $0?.windows.first } ?? UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
			}
			return UIApplication.shared.delegate?.window ?? nil
		}
	}
}

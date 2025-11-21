//
//  ReviewAlertRoute.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 19.09.2024.
//

import Foundation
import UIKit

public protocol ReviewAlertRoute where Self: CloseRoute {
	func openReviewAlert()
}

public extension ReviewAlertRoute {
	func openReviewAlert() {
		let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		
		if var topController = keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			
			let transition = AlertTransition(fromViewController: topController)
			let controller = ReviewAlertController()
			controller.router = ReviewAlertRouter(viewController: controller, fromTransition: transition)
			transition.open(controller, animated: true, completion: nil)
		}}
}

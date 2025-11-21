//
//	AlertRoute.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 23.08.2022.
//

import Foundation
import UIKit

public protocol AlertRoute where Self: CloseRoute {
	func openAlert(title: String?, message: String?, actions: [AlertAction])
	func openDoneAlert(title: String?, message: String, style: NotificationAlertStyle)
	func openSettingsAlert(title: String?, message: String?)
}

public extension AlertRoute {
	func openAlert(title: String? = nil, message: String? = nil, actions: [AlertAction]) {
		let transition = AlertTransition(fromViewController: viewController)
		let controller = AlertController(title: title, message: message)
		controller.router = AlertRouter(viewController: controller, fromTransition: transition)
		controller.setActions(actions)
		transition.open(controller, animated: true, completion: nil)
	}
	
	func openDoneAlert(title: String? = nil, message: String, style: NotificationAlertStyle = .default) {
		var isAllowedToShow = true
		for view in UIWindow.appWindow?.subviews ?? [] {
			if (view as? NotificationAlertView)?.style == style && (view as? NotificationAlertView)?.title == message {
				isAllowedToShow = false
			}
		}
		if isAllowedToShow {
			let transition = NotificationTransition(fromViewController: viewController)
			let controller = NotificationAlertController(title: message, style: style)
			controller.router = NotificationAlertRouter(viewController: controller, fromTransition: transition)
			transition.open(controller, animated: true, completion: nil)
		}
	}
	
	func openSettingsAlert(title: String? = nil, message: String? = nil) {
		let settingsAction = AlertAction(title: LS.Common.Label.settings.localized, style: .destructive, action: {
			UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
		})
		let cancelAction = AlertAction(title: LS.Common.Label.cancel.localized, style: .cancel) {}
		openAlert(title: title ?? LS.Common.Label.oops.localized, message: message ?? LS.Common.Label.unknownErrorOccurred.localized, actions: [settingsAction, cancelAction])
	}
}

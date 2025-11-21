//
//	SafariRoute.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 25.08.2022.
//

import Foundation
import SafariServices

public protocol SafariRoute where Self: RouterProtocol {
	func openSafari(url: String)
}

public extension SafariRoute {
	func openSafari(url: String) {
		guard let url = URL(string: url) else { return }
		let safariController = SFSafariViewController(url: url)
		let transition = ModalTransition(fromViewController: viewController)
		transition.open(safariController, animated: true, completion: nil)
	}
}

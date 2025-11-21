//
//  MailRoute.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 03.03.2023.
//

import UIKit

public protocol MailRoute where Self: RouterProtocol {
	func openMail()
}

public extension MailRoute {
	func openMail() {
		let email = "addons.skins.maps.mcpe@gmail.com"
		if let url = URL(string: "mailto:\(email)") {
			UIApplication.shared.open(url)
		}
	}
}

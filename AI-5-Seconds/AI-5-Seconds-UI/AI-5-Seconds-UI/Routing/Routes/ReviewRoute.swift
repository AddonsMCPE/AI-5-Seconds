//
//  ReviewRoute.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 24.04.2024.
//

import Foundation
import StoreKit

public protocol ReviewRoute where Self: RouterProtocol {
	func openReview()
}

public extension ReviewRoute {
	func openReview() {
		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
			SKStoreReviewController.requestReview(in: windowScene)
		}
	}
}

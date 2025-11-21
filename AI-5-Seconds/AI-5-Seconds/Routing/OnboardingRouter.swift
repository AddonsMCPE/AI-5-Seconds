//
//  OnboardingRouter.swift
//  AI-Charades
//
//  Created by Anna Radchenko on 14.09.2025.
//

import UIKit
import AI_Charades_UI
import AI_Charades_Onboarding
import AI_Charades_WebView
import AI_Charades_Game

final class OnboardingRouter: Router, AI_Charades_Onboarding.OnboardingRouter {
	// MARK: - Properties
	
	var rootTransition: TransitionProtocol {
		let window = UIApplication.shared.keyWindow!
		return RootTransition(window: window)
	}
	
	// MARK: - Router methods
	
	func toGame() {
		openCharadesHome(transition: self.rootTransition, router: CharadesHomeRouter.self)
	}
	
	func toSafari(title: String, url: String) {
		let transition = ModalTransition(fromViewController: viewController)
		openWebView(title: title, urlString: url, transition: transition, router: WebViewRouter.self)
	}
}

extension OnboardingRouter: WebViewRoute {}
extension OnboardingRouter: CharadesHomeRoute {}

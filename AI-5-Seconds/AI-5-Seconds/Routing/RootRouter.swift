//
//  RootRouter.swift
//  AI-Charades
//
//  Created by Anna Radchenko on 14.09.2025.
//


import UIKit
import AI_Charades_UI
import AI_Charades_Splash

final class RootRouter: Router {
	// MARK: - Router methods
	
	func toSplash(window: UIWindow) {
		openSplash(transition: RootTransition(window: window), router: SplashRouter.self)
	}
}

extension RootRouter: SplashRoute {}

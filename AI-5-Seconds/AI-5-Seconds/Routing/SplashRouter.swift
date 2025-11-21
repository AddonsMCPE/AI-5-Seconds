//
//  SplashRouter.swift
//  AI-Charades
//
//  Created by Anna Radchenko on 14.09.2025.
//


import UIKit
import AI_Charades_UI
import AI_Charades_Splash
import AI_Charades_Onboarding
import AI_Charades_Game
import AI_Charades_Services

final class SplashRouter: Router, AI_Charades_Splash.SplashRouter {
	// MARK: - Properties
	
	var rootTransition: TransitionProtocol {
		let window = UIApplication.shared.keyWindow!
		return RootTransition(window: window)
	}
	
	// MARK: - Methods
	
	func toOnboarding() {
		analyticsService().logEvent(name: "Splash_Passed_Custom")
		openOnboarding(transition: self.rootTransition, router: OnboardingRouter.self)
	}
	
	func toGame() {
		openCharadesHome(transition: self.rootTransition, router: CharadesHomeRouter.self)
	}
	
	func toGame(splashAdsService: AI_Charades_Services.AdsSplashInterstitialService) {
		if splashAdsService.interstitial == nil {
			openCharadesHome(transition: self.rootTransition, router: CharadesHomeRouter.self)
		} else {
			splashAdsService.showInterstital(from: viewController, completionHandler: { [weak self] in
				guard let self else { return }
				self.openCharadesHome(transition: self.rootTransition, router: CharadesHomeRouter.self)
			})
		}
	}
}

extension SplashRouter: OnboardingRoute {}
extension SplashRouter: CharadesHomeRoute {}

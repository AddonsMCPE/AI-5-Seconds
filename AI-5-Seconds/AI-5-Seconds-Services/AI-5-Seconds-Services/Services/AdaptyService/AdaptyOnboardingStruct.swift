//
//  AdaptyOnboardingStruct.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 14.10.2024.
//

import Adapty

public struct AdaptyPaywallStruct {
	public var paywall: AdaptyPaywall?
	public var name: String
	public var products: [String: AdaptyPaywallProduct?]
}

final class AdaptyOnboardingClass {
	static let shared = AdaptyOnboardingClass()
	
	//MARK: - onboarding
	
	var scrollablePaywallView: AdaptyPaywallStruct = .init(
		name: "ScrollablePaywallView",
		products: [
			.weekTrial: nil,
			.annual: nil,
			.lifetime: nil
		]
	)
	
	//MARK: - inApp
	
	var mainScrollablePaywallView: AdaptyPaywallStruct = .init(
		name: "MainScrollablePaywallView",
		products: [
			.weekTrial: nil,
			.annual: nil,
			.lifetime: nil
		]
	)
	
	//MARK: - discount
	
	var discountYear: AdaptyPaywallStruct = .init(
		name: "discountYear",
		products: [
			.annualTrialDiscount: nil
		]
	)
	
	// MARK: - Properties
	
	func parsingPaywalls(placement: AdaptyPlacementId, paywall: AdaptyPaywall) -> AdaptyPaywallStruct? {
		var adaptyPaywalls: [AdaptyPaywallStruct] = []
		
		if placement == .onboarding {
			adaptyPaywalls = [
				scrollablePaywallView
			]
		} else if placement == .inApp {
			adaptyPaywalls = [
				mainScrollablePaywallView
			]
		} else if placement == .discount {
			adaptyPaywalls = [
				discountYear
			]
		}
		
		var adaptyPaywall = adaptyPaywalls.first(where: {
			$0.name == paywall.name
		})
		adaptyPaywall?.paywall = paywall
		return adaptyPaywall
	}
}

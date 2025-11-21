//
//	Services.swift
//	AI-Charades-Services
//
//	Created by Anna Radchenko on 01.12.2022.

import Foundation
import AI_Charades_UI

// MARK: - Ads services

public func unityAdsService() -> UnityAdsService {
	return UnityAdsService()
}

public func gdprService() -> GDPRService {
	return GDPRService.shared
}

public func adsRewardService() -> AdsRewardService {
	return AdsRewardService.shared
}

public func adsInterstitialSplashService() -> AdsSplashInterstitialService {
	return AdsSplashInterstitialService()
}

// MARK: - Other services

public func videoFileService() -> VideoFileService {
	return VideoFileService.shared
}

public func timeCounterService() -> TimeCounterService {
	let timeService = TimeCounterService(
		config: .init(
			minSeconds: 30,
			maxSeconds: 300,
			step: 10,
			defaultSeconds: 60,
			defaultsKey: "round.length.seconds"
		)
	)
	return timeService
}

public func deckWordsService(deck: DeckKind) -> DeckWordsService {
	return DeckWordsService(deck: deck)
}

public func playersService() -> PlayersService {
	return PlayersService.shared
}

public func deckService() -> DeckService {
	let deckService = DeckService()
	deckService.setPreferredLanguageCode(UserDefaults.decksLanguage)
	return deckService
}

public func remoteConfigManager() -> RemoteConfigManager {
	return RemoteConfigManager.shared
}

public func adaptyService() -> AdaptyService {
	return AdaptyService.shared
}

public func paywallService() -> PaywallService {
	return PaywallService.shared
}

public func promotionalService() -> PromotionalService {
	return PromotionalService()
}

public func analyticsService() -> AnalyticsService {
	return AnalyticsService()
}

public func networkService() -> NetworkService {
	return NetworkService()
}

public func aiService() -> AiService {
	return AiService()
}

//
//	UserDefaults+Constants.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 03.08.2022.
//

import Foundation
import UIKit

public extension UserDefaults {
	// MARK: - Bool values
	
	static var premium: Bool {
		get {
			UserDefaults.standard.bool(forKey: "premiumKey")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "premiumKey")
			UserDefaults.standard.synchronize()
		}
	}
	
	@UserDefaultsWrapper(key: "isOnboardingPaywallShowedKey", defaultValue: false)
	static var isOnboardingPaywallShowed: Bool
	
	@UserDefaultsWrapper(key: "isFirstShowedKey", defaultValue: false)
	static var isFirstShowed: Bool
	
	@UserDefaultsWrapper(key: "isPromoShowedKey", defaultValue: false)
	static var isPromoShowed: Bool
	
	@UserDefaultsWrapper(key: "isReviewAlertShowedKey", defaultValue: false)
	static var isReviewAlertShowed: Bool
	
	@UserDefaultsWrapper(key: "remoteConfigValueKey", defaultValue: false)
	static var remoteConfigValue: Bool
	
	@UserDefaultsWrapper(key: "isGameRecordTurnOnKey", defaultValue: false)
	static var isGameRecordTurnOn: Bool
	
	@UserDefaultsWrapper(key: "isInstructionShowedKey", defaultValue: false)
	static var isInstructionShowed: Bool
	
	@UserDefaultsWrapper(key: "isVideoPlayerOpenKey", defaultValue: false)
	static var isVideoPlayerOpen: Bool
	
	@UserDefaultsWrapper(key: "isVideoMoreOpenKey", defaultValue: false)
	static var isVideoMoreOpen: Bool
	
	@UserDefaultsWrapper(key: "isPlayerHintShowedKey", defaultValue: false)
	static var isPlayerHintShowed: Bool
	
	@UserDefaultsWrapper(key: "isVideoHintShowedKey", defaultValue: false)
	static var isVideoHintShowed: Bool
	
	// MARK: - String values
	
	@UserDefaultsWrapper(key: "weekTrialCostKey", defaultValue: "$3.99")
	static var weekTrialCost: String
	
	@UserDefaultsWrapper(key: "annualCostKey", defaultValue: "$29.99")
	static var annualCost: String
	
	@UserDefaultsWrapper(key: "lifetimeCostKey", defaultValue: "$49.99")
	static var lifetimeCost: String
	
	@UserDefaultsWrapper(key: "annualTrialDiscountCostKey", defaultValue: "$19.99")
	static var annualTrialDiscountCost: String
	
	@UserDefaultsWrapper(key: "decksLanguageKey", defaultValue: "")
	static var decksLanguage: String
	
	// MARK: - Int value
	
	@UserDefaultsWrapper(key: "paywallCounterKey", defaultValue: 2)
	static var paywallCounter: Int
	
	@UserDefaultsWrapper(key: "discountCounterKey", defaultValue: 0)
	static var discountCounter: Int
	
	@UserDefaultsWrapper(key: "reviewCounterKey", defaultValue: 1)
	static var reviewCounter: Int
	
	@UserDefaultsWrapper(key: "actualPromotionalKey", defaultValue: 0)
	static var actualPromotional: Int
	
	@UserDefaultsWrapper(key: "wordsCountInCustom1Key", defaultValue: 0)
	static var wordsCountInCustom1: Int
	
	@UserDefaultsWrapper(key: "wordsCountInAiDeckKey", defaultValue: 0)
	static var wordsCountInAiDeck: Int
	
	static func isDiscountPresenting(with stepChanger: Bool = true) -> Bool {
		if UserDefaults.premium {
			return false
		}
		if stepChanger {
			UserDefaults.discountCounter += 1
		}
		if UserDefaults.discountCounter % 1 == 0 {
			return true
		} else {
			return false
		}
	}
	
	static func isReviewAlertPresenting(with stepChanger: Bool = true) -> Bool {
		if UserDefaults.isReviewAlertShowed {
			return false
		}
		if stepChanger {
			UserDefaults.reviewCounter += 1
		}
		if UserDefaults.reviewCounter % 3 == 0 {
			return true
		} else {
			return false
		}
	}
	
	static func isVideoPlayerOpened() -> Bool {
		if UserDefaults.premium {
			return false
		}
		if !UserDefaults.isVideoPlayerOpen {
			UserDefaults.isVideoPlayerOpen = true
			return false
		} else {
			return true
		}
	}
	
	static func isVideoMoreOpened() -> Bool {
		if UserDefaults.premium {
			return false
		}
		if !UserDefaults.isVideoMoreOpen {
			UserDefaults.isVideoMoreOpen = true
			return false
		} else {
			return true
		}
	}
}

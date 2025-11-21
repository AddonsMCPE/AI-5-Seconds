//
//  AdaptyService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 14.10.2024.
//

import Adapty
import SwiftyStoreKit
import StoreKit
import AI_Charades_UI

enum AdaptyPlacementId: String, CaseIterable {
	case onboarding
	case inApp
	case discount
	
	var rawValue: String {
		let isSandbox = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
		switch self {
		case .onboarding:
			return !isSandbox ? "Production_onboarding" : "Test_onboarding"
		case .inApp:
			return !isSandbox ? "Production_inApp" : "Test_inApp"
		case .discount:
			return !isSandbox ? "Production_discount" : "Test_discount"
		}
	}
}

public enum AdaptyPurchaseResult {
	case success, error, canceled
}

public class AdaptyService {
	public typealias Observer = () -> ()
	
	// MARK: - Singleton
	
	static let shared = AdaptyService()
	
	// MARK: - Properties
	
	public var observer: Observer?
	
	public var onboardingPaywallStruct: AdaptyPaywallStruct?
	public var inAppPaywallStruct: AdaptyPaywallStruct?
	public var discountPaywallStruct: AdaptyPaywallStruct?
	
	// MARK: - Methods
	
	public func configure(
		firebaseAppInstanceId: String?,
		facebookAnonymousID: String?,
		delegate: AdaptyDelegate?,
		firebaseErrorHandler: (()->())?,
		facebookErrorHandler: (()->())?
	) {
		let configurationBuilder = AdaptyConfiguration
			.builder(withAPIKey: "public_live_P9x2Qm7Vt3Kc5Rz1Jn8Fb4Wg6Yh0Sa3L")
			.with(observerMode: false)
			.with(idfaCollectionDisabled: false)
			.with(ipAddressCollectionDisabled: false)
		
		Adapty.activate(with: configurationBuilder.build()) { error in
			guard let error else {
				print("AdaptyActivated")
				return
			}
			print("Adapty Error \(error.localizedDescription)")
		}
		Adapty.delegate = delegate
		
		adaptyUpdateForFirebase(firebaseAppInstanceId: firebaseAppInstanceId, firebaseErrorHandler: firebaseErrorHandler)
		
		adaptyUpdateForFacebook(facebookAnonymousID: facebookAnonymousID, facebookErrorHandler: facebookErrorHandler)
		
		SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
			for purchase in purchases {
				switch purchase.transaction.transactionState {
				case .purchased, .restored:
					if purchase.needsFinishTransaction {
						SwiftyStoreKit.finishTransaction(purchase.transaction)
					}
				case .failed, .purchasing, .deferred:
					break
				@unknown default:
					break
				}
			}
		}
		
		fetchAdaptyPlacements()
	}
	
	public func adaptyUpdateForFirebase(
		firebaseAppInstanceId: String?,
		firebaseErrorHandler: (()->())?
	) {
		DispatchQueue.main.async {
			Task {
				if let firebaseAppInstanceId {
					do {
						try await Adapty.setIntegrationIdentifier(
							key: "firebase_app_instance_id",
							value: firebaseAppInstanceId
						)
					} catch {
						firebaseErrorHandler?()
					}
				}
			}
		}
	}
	
	public func adaptyUpdateForFacebook(
		facebookAnonymousID: String?,
		facebookErrorHandler: (()->())?
	) {
		if let facebookAnonymousID {
			DispatchQueue.main.async {
				Task {
					do {
						try await Adapty.setIntegrationIdentifier(
							key: "facebook_anonymous_id",
							value: facebookAnonymousID
						)
					} catch {
						facebookErrorHandler?()
					}
				}
			}
		}
	}
	
	public func makePurchase(id: String? = nil, product: AdaptyPaywallProduct?, completion: @escaping (AdaptyPurchaseResult)->()) {
		if let adaptyPaywallProduct = product {
			analyticsService().logEvent(name: "Adapty_make_adapty_purchase")
			Adapty.makePurchase(product: adaptyPaywallProduct) { result in
				
				switch result {
				case let .success(purchaseResult):
					switch purchaseResult {
					case .pending:
						completion(.error)
					case .userCancelled:
						completion(.canceled)
					case .success(_, _):
						completion(.success)
					}
				case let .failure(error):
					switch error.adaptyErrorCode.rawValue {
					case 1: analyticsService().logEvent(name: "Adapty_sub_account_error_adapty")
					case 2:
						analyticsService().logEvent(name: "Adapty_payment_screen_close_adapty")
						completion(.canceled)
						return
					case 3: analyticsService().logEvent(name: "Adapty_payment_card_failed_adapty")
					case 4: analyticsService().logEvent(name: "Adapty_payment_not_allowed_adapty")
					case 7: analyticsService().logEvent(name: "Adapty_payment_internet_error_adapty")
					case 11: analyticsService().logEvent(name: "Adapty_product_error_adapty")
					case 12: analyticsService().logEvent(name: "Adapty_promotion_offer_error_adapty")
					case 14: analyticsService().logEvent(name: "Adapty_error_price_adapty")
					case 17: analyticsService().logEvent(name: "Adapty_purchase_time_out_adapty")
					case 20: analyticsService().logEvent(name: "Adapty_overlay_subs_adapty")
					default:
						analyticsService().logEvent(name: "Adapty_unowned_payment_error_adapty")
					}
					completion(.error)
				}
			}
		} else {
			if let id = id {
				analyticsService().logEvent(name: "StoreKit_make_storekit_purchase")
				SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
					switch result {
					case .success(_):
						completion(.success)
					case .error(let error):
						switch error.code {
						case .clientInvalid: analyticsService().logEvent(name: "StoreKit_sub_account_error_storekit")
						case .paymentCancelled: analyticsService().logEvent(name: "StoreKit_payment_screen_close_storekit")
							completion(.canceled)
							return
						case .paymentInvalid: analyticsService().logEvent(name: "StoreKit_payment_card_failed_storekit")
						case .paymentNotAllowed: analyticsService().logEvent(name: "StoreKit_payment_not_allowed_storekit")
						case .cloudServiceNetworkConnectionFailed: analyticsService().logEvent(name: "StoreKit_payment_internet_error_storekit")
						case .invalidOfferIdentifier: analyticsService().logEvent(name: "StoreKit_product_error_storekit")
						case .invalidSignature: analyticsService().logEvent(name: "StoreKit_promotion_offer_error_storekit")
						case .invalidOfferPrice: analyticsService().logEvent(name: "StoreKit_error_price_storekit")
						case .overlayTimeout: analyticsService().logEvent(name: "StoreKit_purchase_time_out_storekit")
						case .overlayPresentedInBackgroundScene: analyticsService().logEvent(name: "StoreKit_overlay_subs_storekit")
						default: analyticsService().logEvent(name: "StoreKit_unowned_payment_error_storekit")
						}
						completion(.error)
					@unknown default:
						analyticsService().logEvent(name: "StoreKit_unowned_payment_error_storekit")
						completion(.error)
					}
				}
			} else {
				completion(.error)
			}
		}
	}
	
	public var adaptyDeferredProduct: AdaptyDeferredProduct?
	
	public func makePromoPurchase(for product: AdaptyDeferredProduct, completion: @escaping (Bool)->()) {
		Task {
			await continueDeferredPurchase(for: product, completion: completion)
		}
	}
	
	private func continueDeferredPurchase(for product: AdaptyDeferredProduct, completion: @escaping (Bool)->()) async {
		do {
			let result = try await Adapty.makePurchase(product: product)
			switch result {
			case .userCancelled:
				completion(false)
			case .pending:
				completion(false)
			case .success(_, _):
				completion(true)
			}
		} catch {
			completion(false)
		}
	}
	
	public func restorePurchases(completion: @escaping (Bool)->()) {
		SwiftyStoreKit.restorePurchases(atomically: true) { results in
			if results.restoreFailedPurchases.count > 0 {
				completion(false)
			}
			else if results.restoredPurchases.count > 0 {
				completion(true)
			}
			else {
				completion(false)
			}
		}
//		Adapty.restorePurchases { [weak self] result in
//			switch result {
//			case let .success(profile):
//				if profile.accessLevels["premium"]?.isActive ?? false {
//					completion(true)
//				} else {
//					completion(false)
//				}
//			case let .failure(error):
//				completion(false)
//			}
//		}
	}
	
	public func checkSubscription(completion: @escaping (Bool)->()) {
		var canceled: Bool = false
		let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: .sharedSecretSubscription)
		SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
			switch result {
			case .success(let receipt):
			
				let subs: [String] = [
					.weekTrial,
					.annual,
					.annualTrialDiscount
				]
				
				switch SwiftyStoreKit.verifyPurchase(productId: .lifetime, inReceipt: receipt) {
				case .purchased(_):
					completion(true)
					return
				case .notPurchased:
					canceled = true
				@unknown default:
					canceled = true
				}
				
				for sub in subs {
					switch SwiftyStoreKit.verifySubscription(
						ofType: .autoRenewable,
						productId: sub,
						inReceipt: receipt) {
					case .purchased(_, _):
						print("sub = \(sub)")
						completion(true)
						return
					case .expired(_, _):
						canceled = true
					case .notPurchased:
						canceled = true
					@unknown default:
						canceled = true
					}
				}
			
			case .error(let error):
				print("Receipt verification failed: \(error)")
			@unknown default:
				print("Receipt verification failed")
			}
			
			if canceled == true {
				completion(false)
			}
		}
	}
	
	public func logPaywall(_ paywall: AdaptyPaywall?) {
		guard let paywall else { return }
		Adapty.logShowPaywall(paywall)
	}
	
	public func fetchAdaptyPlacements() {
		for adaptyPlacementId in AdaptyPlacementId.allCases {
			Adapty.getPaywall(placementId: adaptyPlacementId.rawValue, { [weak self] result in
				guard let self else { return }
				switch result {
				case .success(let paywall):
                    switch paywall.placement.id {
					case AdaptyPlacementId.onboarding.rawValue:
						self.onboardingPaywallStruct = AdaptyOnboardingClass.shared.parsingPaywalls(
							placement: .onboarding,
							paywall: paywall
						)
					case AdaptyPlacementId.inApp.rawValue:
						self.inAppPaywallStruct = AdaptyOnboardingClass.shared.parsingPaywalls(
							placement: .inApp,
							paywall: paywall
						)
					case AdaptyPlacementId.discount.rawValue:
						self.discountPaywallStruct = AdaptyOnboardingClass.shared.parsingPaywalls(
							placement: .discount,
							paywall: paywall
						)
					default:
						print("")
					}
					self.fetchProductsForPaywall(paywall)
				case .failure(_):
					return
				}
			})
		}
	}
	
	// MARK: Private methods
	
	private func fetchProductsForPaywall(_ paywall: AdaptyPaywall) {
		Adapty.getPaywallProducts(paywall: paywall, { [weak self] result in
			guard let self else { return }
			switch result {
			case .success(let products):
				for product in products {
                    switch paywall.placement.id {
					case AdaptyPlacementId.onboarding.rawValue:
						self.onboardingPaywallStruct?.products[product.vendorProductId] = product
					case AdaptyPlacementId.inApp.rawValue:
						self.inAppPaywallStruct?.products[product.vendorProductId] = product
					case AdaptyPlacementId.discount.rawValue:
						self.discountPaywallStruct?.products[product.vendorProductId] = product
					default:
						print("")
					}
					parsePrices(for: product)
				}
			case .failure(_):
				break
			}
		})
	}
	
	private func parsePrices(for product: AdaptyPaywallProduct) {
		switch product.vendorProductId {
		case .weekTrial:
			guard let priceString = product.localizedPrice else { return }
			UserDefaults.weekTrialCost = priceString
		case .annual:
			guard let priceString = product.localizedPrice else { return }
			UserDefaults.annualCost = priceString
		case .annualTrialDiscount:
			guard let priceString = product.localizedPrice else { return }
			UserDefaults.annualTrialDiscountCost = priceString
		case .lifetime:
			guard let priceString = product.localizedPrice else { return }
			UserDefaults.lifetimeCost = priceString
		default:
			return
		}
	}
	
	private func extractPriceFormatted(from text: String) -> String? {
		let pattern = "\"priceFormatted\"\\s*:\\s*\"([^\"]+)\""
		
		do {
			let regex = try NSRegularExpression(pattern: pattern, options: [])
			let range = NSRange(location: 0, length: text.utf16.count)
			
			if let match = regex.firstMatch(in: text, options: [], range: range) {
				if let valueRange = Range(match.range(at: 1), in: text) {
					return String(text[valueRange])
				}
			}
		} catch {
			print("Invalid regex: \(error.localizedDescription)")
		}
		return nil
	}
}

public extension Double {
	func rounded(toPlaces places: Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
	
	func roundedDown(toPlaces places: Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded(.down) / divisor
	}
}

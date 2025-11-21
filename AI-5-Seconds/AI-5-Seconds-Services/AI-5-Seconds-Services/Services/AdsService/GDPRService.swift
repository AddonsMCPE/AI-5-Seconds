//
//  GDPRService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 16.01.2024.
//

import Foundation
import UserMessagingPlatform
import GoogleMobileAds

public class GDPRService {
	public static var shared: GDPRService = GDPRService()
	public var canRequestAds: Bool = false
	
	public func configure(from viewController: UIViewController, completion: @escaping ((Bool) -> Void)) {
		ConsentInformation.shared.requestConsentInfoUpdate(with: nil) {
			[weak self] requestConsentError in
			guard let self else { return }

			if let consentError = requestConsentError {
				completion(false)
			return print("ErroЕЕr: \(consentError.localizedDescription)")
			}
			
			ConsentForm.loadAndPresentIfRequired(from: viewController) {
				[weak self] loadAndPresentError in
				guard let self else { return }

				if let consentError = loadAndPresentError {
					completion(false)
				return print("ErroЕЕr: \(consentError.localizedDescription)")
				}

				if ConsentInformation.shared.canRequestAds {
					self.canRequestAds = true
					GoogleAdsService.configure(adsLoadingHandler: {
						if !UserDefaults.premium {
							AppOpenAdManager.shared.isShowingAd = false
						}
					})
					completion(true)
				} else {
					completion(false)
				}
			}
		}
	}
	
	public func presentPrivacyForm(from viewController: UIViewController) {
		ConsentForm.presentPrivacyOptionsForm(from: viewController, completionHandler: nil)
	}
	
	// MARK: - Private methods
	
	private func testEuropeParametrs() -> RequestParameters {
		let parameters = RequestParameters()
		let debugSettings = DebugSettings()
		debugSettings.testDeviceIdentifiers = ["566B2E7D-5252-402D-A622-81B06A776506"]
		debugSettings.geography = .EEA
		parameters.debugSettings = debugSettings
		return parameters
	}
}

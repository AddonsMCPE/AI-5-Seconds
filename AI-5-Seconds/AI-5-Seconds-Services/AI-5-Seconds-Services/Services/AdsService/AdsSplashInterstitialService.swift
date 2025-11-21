//
//  AdsSplashInterstitialService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 27.02.2025.
//

import Foundation
import UIKit
import AI_Charades_UI
import GoogleMobileAds

public enum AdsSplashInterstitialResult {
	case adsIsReady(_ _bool: Bool)
}

public class AdsSplashInterstitialService: NSObject, FullScreenContentDelegate {
	public typealias Observer = (AdsSplashInterstitialResult) -> ()
	
	// MARK: - Public properties
	
	public var observer: Observer?
	public var interstitial: InterstitialAd?
	
	// MARK: - Private properties
	
	private var isAutoAds: Bool = false
	private var waitingTimer = Timer()
	private let interAdsId: String = AdsConstants.monthStartManual
	private var interstitialCompletionHandler: (()->())?
	
	// MARK: - Inits
	
	public override init() {
		super.init()
	}
	
	// MARK: - Public methods
	
	public func loadAds() {
		waitingTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { [weak self] _ in
			self?.observer?(.adsIsReady(false))
			self?.waitingTimer.invalidate()
		})
		loadInterstitial()
	}
	
	public func showInterstitialFromMain(from viewController: UIViewController?, completionHandler: (()->())?) {
		showInterstital(from: viewController, completionHandler: completionHandler)
	}
	
	public func showInterstital(from viewController: UIViewController?, completionHandler: (()->())?) {
		guard let _viewController = viewController else {
			completionHandler?()
			return
		}
		guard let _interstitial = interstitial else {
			completionHandler?()
			return
		}
		if (UserDefaults.premium) {
			completionHandler?()
			return
		}
		interstitialCompletionHandler = completionHandler
		_interstitial.present(from: _viewController)
	}
	
	// MARK: - Private methods
	
	@objc private func loadInterstitial() {
		if !gdprService().canRequestAds {
			return
		}
		if !(UserDefaults.premium) {
			if self.interstitial == nil {
				let request = Request()
				InterstitialAd.load(with: self.interAdsId, request: request, completionHandler: { [self] ad, error in
					if let error = error {
						print("INTERSTITIAL ADS block = \(self.interAdsId) is failed to load interstitial ad with error: \(error.localizedDescription)")
						self.interstitialCompletionHandler?()
						self.interstitialCompletionHandler = nil
						self.interstitial = nil
						self.observer?(.adsIsReady(false))
						return
					}
					self.interstitial = ad
					if ad != nil {
						self.waitingTimer.invalidate()
					}
					self.interstitial?.fullScreenContentDelegate = self
					self.observer?(.adsIsReady(true))
				})
			}
		}
	}
	
	// MARK: - GADFullScreenContentDelegate
	
	public func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
		switch ad {
		case is InterstitialAd:
			interstitialCompletionHandler?()
			interstitialCompletionHandler = nil
			interstitial = nil
		default:
			return
		}
	}
	
	public func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
		print("Ad will present full screen content. \(interAdsId)")
		UIApplication.shared.isStatusBarHidden = true
	}
	
	public func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) {
			UIApplication.shared.isStatusBarHidden = false
			switch ad {
			case is InterstitialAd:
				self.interstitial = nil
				self.interstitialCompletionHandler?()
				self.interstitialCompletionHandler = nil
			default:
				return
			}
		}
	}

	public func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {}
}

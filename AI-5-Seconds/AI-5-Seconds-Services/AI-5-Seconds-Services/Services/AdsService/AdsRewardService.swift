//
//  AdsRewardService.swift
//  IA_Minecraft-Services
//
//  Created by Anna Radchenko on 12.03.2025.
//

import Foundation
import UIKit
import AI_Charades_UI
import GoogleMobileAds

public final class AdsRewardService: NSObject, FullScreenContentDelegate {
	// MARK: - Singleton
	
	static let shared = AdsRewardService()
	
	// MARK: - Inits
	
	public override init() {
		super.init()
		if !(UserDefaults.premium) {
			loadRewardedAd()
		}
	}
	
	// MARK: - Private properties
	
	private var rewardErrorTimer = Timer()
	private var rewardCompletionHandler: (()->())?
	private var rewardErrorHandler: (()->())?
	private var rewardedAd: RewardedAd?

	// MARK: - Public methods
	
	public func showReward(from viewController: UIViewController?, completionHandler: (()->())?) {
		if (UserDefaults.premium) {
			completionHandler?()
			return
		}
		guard let _viewController = viewController else {
			completionHandler?()
			return
		}
		guard let _rewardedAd = rewardedAd else {
			completionHandler?()
			return
		}
		
		rewardCompletionHandler = nil
		rewardErrorHandler = completionHandler
		
		_rewardedAd.present(from: _viewController) {
			let reward = _rewardedAd.adReward
			print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
			// TODO: Reward the user.
			self.rewardCompletionHandler = completionHandler
		}
	}
	
	// MARK: - Private methods
	
	@objc private func loadRewardedAd() {
		let request = Request()
		RewardedAd.load(with: AdsConstants.admobRewardID,
											 request: request,
											 completionHandler: { [self] ad, error in
			if let error = error {
				print("Failed to load rewarded ad with error: \(error.localizedDescription)")
				rewardErrorTimer.invalidate()
				rewardErrorTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(loadRewardedAd), userInfo: nil, repeats: false)
				return
			}
			rewardedAd = ad
			print("Rewarded ad loaded.")
			rewardedAd?.fullScreenContentDelegate = self
		})
	}
	
	// MARK: - GADFullScreenContentDelegate
	
	public func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
		switch ad {
		case is RewardedAd:
			rewardErrorHandler?()
			rewardedAd = nil
			rewardErrorTimer.invalidate()
			rewardErrorTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(loadRewardedAd), userInfo: nil, repeats: false)
		default:
			return
		}
	}
	
	public func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
		print("Ad will present full screen content.")
	}

	public func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
		switch ad {
		case is RewardedAd:
			rewardedAd = nil
			rewardCompletionHandler?()
			loadRewardedAd()
		default:
			return
		}
	}
}

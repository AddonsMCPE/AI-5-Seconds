//
//  AdsService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 16.01.2024.
//

import UIKit
import GoogleMobileAds

public final class GoogleAdsService {
	public static func configure(adsLoadingHandler: (()->())?) {
		
		let ads = MobileAds.shared
		ads.start { status in
			let adapterStatuses = status.adapterStatusesByClassName
			for adapter in adapterStatuses {
				let adapterStatus = adapter.value
				NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key,
				adapterStatus.description, adapterStatus.latency)
			}
			adsLoadingHandler?()
		}
		
		MobileAds.shared.disableSDKCrashReporting()
	}
	
	public static func presentAdsInspector(from viewController: UIViewController) {
		MobileAds.shared.presentAdInspector(from: viewController)
	}
}

//
//  UnityAdsService.swift
//  IA_Minecraft-Services
//
//  Created by Anna Radchenko on 03.04.2025.
//

import UnityAds

public final class UnityAdsService {
	public func intergate() {
		UnityAds.initialize("unity_ads_code", testMode: true)
	}
}

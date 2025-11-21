//
//  RemoteConfigService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 19.11.2023.
//

import Foundation
import FirebaseRemoteConfig

public class RemoteConfigManager {
	static let shared = RemoteConfigManager()
	private let remoteConfig = RemoteConfig.remoteConfig()
	
	private init() {
		let settings = RemoteConfigSettings()
		settings.minimumFetchInterval = 3600
		remoteConfig.configSettings = settings
	}
	
	public func fetchRemoteConfig(completion: @escaping (Bool) -> Void) {
		remoteConfig.fetchAndActivate { status, error in
			if let error = error {
				print("Ошибка загрузки Remote Config: \(error)")
				completion(false)
				return
			}
			let message = self.remoteConfig["isOnReview"].boolValue
			completion(message)
		}
	}
}

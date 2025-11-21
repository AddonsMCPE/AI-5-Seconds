//
//  FacebookService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 16.01.2024.
//

import FBSDKCoreKit

public final class FacebookService {
	public static func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
		ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
		Settings.shared.isAutoLogAppEventsEnabled = true
		Settings.shared.isAdvertiserIDCollectionEnabled = true
	}
	
	public static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		return ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
	}
	
	public static func application(_ application: UIApplication, continue userActivity: NSUserActivity) {
		ApplicationDelegate.shared.application(application, continue: userActivity)
	}
	
	public static func isAdvertiserTrackingEnabled(_ bool: Bool) {
		Settings.shared.isAdvertiserTrackingEnabled = bool
		Settings.shared.advertisingTrackingStatus = bool ? .allowed : .disallowed
	}
	
	public static func sendFacebookEvent(with name: String) {
		AppEvents.shared.logEvent(AppEvents.Name(name))
	}
}

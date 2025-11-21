//
//  AppDelegate.swift
//  AI-5-Seconds
//
//  Created by Oleksandr Yakobshe on 21.11.2025.
//

import UIKit
import AI_Charades_UI
import AI_Charades_Splash
import AI_Charades_Services
import Firebase
import SwiftyStoreKit
import FirebaseMessaging
import Adapty

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var deviceToken = Data()
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//		FacebookService.application(application, didFinishLaunchingWithOptions: launchOptions)
		
		loadFonts()
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: .main).instantiateInitialViewController()
		window?.makeKeyAndVisible()
		
//		unityAdsService().intergate()
		
		FirebaseApp.configure()
		Analytics.setConsent([
			.analyticsStorage: .granted,
			.adStorage: .granted,
			.adUserData: .granted,
			.adPersonalization: .granted,
		])
		
		remoteConfigManager().fetchRemoteConfig() { bool in
			UserDefaults.remoteConfigValue = bool
		}
//		adaptyService().configure(
//			firebaseAppInstanceId: Analytics.appInstanceID(),
//			facebookAnonymousID: nil,
//			delegate: self,
//			firebaseErrorHandler: {
//				analyticsService().logEvent(name: "adapty_firebase_integration_error")
//			},
//			facebookErrorHandler: {
//				analyticsService().logEvent(name: "adapty_facebook_integration_error")
//			}
//		)
		Messaging.messaging().delegate = self
		application.registerForRemoteNotifications()
		UNUserNotificationCenter.current().delegate = self
		
		_ = promotionalService().actualPromotional
		
		SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in
			return true
		}
		
		SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
			for purchase in purchases {
				switch purchase.transaction.transactionState {
				case .purchased, .restored:
					UserDefaults.premium = true
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
		
		DispatchQueue.main.async {
			RootRouter().toSplash(window: self.window!)
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(updateDeviceToken), name: .firebaseMessagingDidChange, object: nil)
		
		UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
		
		return true
	}
	
//	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//		return FacebookService.application(app, open: url, options: options)
//	}
	
	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//		FacebookService.application(application, continue: userActivity)
		return true
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		UIApplication.shared.applicationIconBadgeNumber = 0
		
		let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

		if var topController = keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			if !UserDefaults.premium {
				if !String(describing: topController).contains("GADFullScreenAdViewController") &&
					!String(describing: topController).contains("PaywallViewController") {
					AppOpenAdManager.shared.showAdIfAvailable(viewController: topController)
				}
			}
		}
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		AppOpenAdManager.shared.isShowingAd = true
		UIApplication.shared.applicationIconBadgeNumber = 0
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		AppOpenAdManager.shared.isShowingAd = false
	}
	
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		if OrientationManager.landscapeSupported {
			return .landscape
		}
		return .portrait
	}
	
	// MARK: - Actions
	
	@objc private func updateDeviceToken() {
		if !UserDefaults.premium {
			Messaging.messaging().apnsToken = self.deviceToken
		} else {
			Messaging.messaging().apnsToken = Data()
		}
	}
	
	// MARK: - Private methods
	
	private func loadFonts() {
		let fonts = Bundle.uiBundle.urls(forResourcesWithExtension: "ttf", subdirectory: nil)
		fonts?.forEach({ url in
			CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
		})
	}
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		self.deviceToken = deviceToken
		updateDeviceToken()
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
		return [[.alert, .sound, .badge]]
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
		return UIBackgroundFetchResult.newData
	}
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
		print("Firebase registration token: \(String(describing: fcmToken))")
		
		let dataDict: [String: String] = ["token": fcmToken ?? ""]
		NotificationCenter.default.post(
			name: Notification.Name("FCMToken"),
			object: nil,
			userInfo: dataDict
		)
	}
}

// MARK: - AdaptyDelegate

//extension AppDelegate: AdaptyDelegate {
//	nonisolated func didLoadLatestProfile(_ profile: AdaptyProfile) {
//		//UserDefaults.premium = profile.accessLevels["premium"]?.isActive ?? false
//	}
//
//	nonisolated func shouldAddStorePayment(for product: AdaptyDeferredProduct) -> Bool {
//		analyticsService().logEvent(name: "Splash_Splash_promo_opened")
//		adaptyService().adaptyDeferredProduct = product
//		return false
//	}
//}

//
//	AnalyticsService.swift
//	AI-Charades-Services
//
//	Created by Anna Radchenko on 01.12.2022.
//

import Foundation
import FirebaseAnalytics

public struct AnalyticsService {
	public func logEvent(name: String, parametrs: [String : AnyObject]? = nil) {
			print("Analytics.logEvent " + name)
		Analytics.logEvent(name, parameters: parametrs)
	}
}

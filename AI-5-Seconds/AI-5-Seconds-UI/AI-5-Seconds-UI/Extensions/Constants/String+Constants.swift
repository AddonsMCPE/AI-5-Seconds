//
//	String+Constants.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 14.08.2022.
//

import Foundation

public extension String {
	static let weekTrial = "rule_sub_week"
	static let annual = "rule_sub_year"
	static let annualTrialDiscount = "rule_sub_discount_trial_annual"
	static let lifetime = "rule_forever"
	
	static let annualTrial = ""
	static let week = ""
	
	static let sharedSecretSubscription = "a16a187cc5a84b6b85cad51bc9690f3e"
}

public extension String {
	static let termsURL = "https://docs.google.com/document/d/1cJlFK8MaoG8wlZHLQCvKLvm88QNo7nmTa3NlnlPMxP4/preview"
	static let privateURL = "https://docs.google.com/document/d/1qHrbJMT6EsiG3ClwrBlt8GfpgeYmOQUal6DSuCr0ys0/preview"
	static let appURL = "https://apps.apple.com/app/id6753877400"
}

public extension String {
	static let email = "annaradchenko088@gmail.com"
	static let appName = "AI Charades - guess the word"
}

public class OrientationManager {
	public static var landscapeSupported: Bool = false
}

//
//	NSNotification+Constraint.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 22.02.2023.
//

import Foundation

extension NSNotification.Name {
	public static let premiumDidChange = NSNotification.Name(rawValue: "premiumDidChange")
	public static let premiumTabBarDidChange = NSNotification.Name(rawValue: "premiumTabBarDidChange")
	public static let themeDidChange = NSNotification.Name(rawValue: "themeDidChange")
	public static let themeDidChangeTabBar = NSNotification.Name(rawValue: "themeDidChangeTabBar")
	public static let firebaseMessagingDidChange = NSNotification.Name(rawValue: "firebaseMessagingDidChange")
}

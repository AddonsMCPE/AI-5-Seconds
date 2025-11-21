//
//  AlertAction.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 24.04.2023.
//

import Foundation

public enum AlertButtonStyle {
	case `default`, destructive, cancel
}

public struct AlertAction {
	public let title: String?
	public let action: (() -> Void)?
	public var style: AlertButtonStyle = .default
	
	public init(title: String?, style: AlertButtonStyle, action: (() -> Void)?) {
		self.title = title
		self.action = action
		self.style = style
	}
	
	public init<L: Localizable>(title: L, style: AlertButtonStyle, action: (() -> Void)?) {
		self.title = title.localized
		self.action = action
		self.style = style
	}
}

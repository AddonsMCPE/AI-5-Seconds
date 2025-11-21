//
//	Common.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.08.2022.
//

import Foundation

public extension LS {
	enum Common {}
	enum Onboarding {}
	enum Paywall {}
	enum Game {}
	enum Minor {}
}

public extension LS.Common {
	enum Label: String, Localizable {
		case doYouLikeOurApp = "LS.Common.Label.doYouLikeOurApp"
	}
}

public extension LS.Minor {
	enum Label: String, Localizable {
		case gameSettings = "LS.Minor.Label.gameSettings"
	}
}

public extension LS.Onboarding {
	enum Label: String, Localizable {
		case pageTitle1 = "LS.Onboarding.Label.pageTitle1"
	}
}

public extension LS.Paywall {
	enum Label: String, Localizable {
		case restore = "LS.Paywall.Label.restore"
	}
}

public extension LS.Game {
	enum Label: String, Localizable {
		case themeAnime = "LS.Game.Label.themeAnime"
	}
}

extension Localizable where Self == LS.Common.Label {
	public var tableName: String? { return "Common" }
}

extension Localizable where Self == LS.Minor.Label {
	public var tableName: String? { return "Common" }
}

extension Localizable where Self == LS.Onboarding.Label {
	public var tableName: String? { return "Common" }
}

extension Localizable where Self == LS.Paywall.Label {
	public var tableName: String? { return "Common" }
}

extension Localizable where Self == LS.Game.Label {
	public var tableName: String? { return "Common" }
}

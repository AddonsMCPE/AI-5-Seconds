//
//  PromotionalService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 20.10.2023.
//

import Foundation

public enum ActualPromotional: Int {
	case regular = 0
	case halloween = 1
	case blackFriday = 2
}

public class PromotionalService {
	public var actualPromotional: ActualPromotional {
		let actualPromotional = getActualPromotional()
		if UserDefaults.actualPromotional != actualPromotional.rawValue {
			UserDefaults.actualPromotional = actualPromotional.rawValue
		}
		return actualPromotional
	}
	
	private func getActualPromotional() -> ActualPromotional {
		let today = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd"
		guard let day = Int(dateFormatter.string(from: today)) else {
			return .regular
		}
		dateFormatter.dateFormat = "MM"
		guard let month = Int(dateFormatter.string(from: today)) else {
			return .regular
		}
		if month == 10 && day >= 20 {
			return .halloween
		} else if month == 11 && day >= 22 && day <= 24 {
			return .blackFriday
		} else {
			return .regular
		}
	}
}

public extension UserDefaults {
	func getActualPromotional() -> ActualPromotional {
		return ActualPromotional(rawValue: UserDefaults.actualPromotional) ?? .regular
	}
}

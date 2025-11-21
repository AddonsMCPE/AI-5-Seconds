//
//  SecretsManager.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 13.09.2025.
//

import Foundation

public struct SecretsManager {
	static public func getValue(for key: String) -> String? {
		guard let path = Bundle.serviceBundle.path(forResource: "constants", ofType: "plist"),
					let dict = NSDictionary(contentsOfFile: path) else {
			return nil
		}
		return dict[key] as? String
	}
}

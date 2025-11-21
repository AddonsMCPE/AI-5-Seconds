//
//  UserDefaultsWrapper.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 22.02.2023.
//

import Foundation

@propertyWrapper
public struct UserDefaultsWrapper<T> {
	private let key: String
	private let defaultValue: T
	
	init(key: String, defaultValue: T) {
		self.key = key
		self.defaultValue = defaultValue
	}

	public var wrappedValue: T {
		get {
			UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
		}
		set {
			UserDefaults.standard.set(newValue, forKey: key)
		}
	}
}

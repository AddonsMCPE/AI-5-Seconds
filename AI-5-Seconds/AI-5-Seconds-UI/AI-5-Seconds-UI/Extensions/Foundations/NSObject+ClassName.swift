//
//	NSObject+ClassName.swift
//	Qibla-UI
//
//	Created by Anna Radchenko on 04.05.2022.
//

import Foundation

public extension NSObject {
	static var className: String {
		return try! String(describing: self).substringMatches(regex: "[[:word:]]+").first!
	}
}

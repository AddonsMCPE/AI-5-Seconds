//
//	Reusable.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.08.2022.
//

import Foundation

public protocol Reusable {
	static var reuseIdentifier: String { get }
	func prepareForReuse()
}

public extension Reusable where Self: AnyObject {
	static var reuseIdentifier: String {
		return try! String(describing: self).substringMatches(regex: "[[:word:]]+").first!
	}
	
	func prepareForReuse() {}
}

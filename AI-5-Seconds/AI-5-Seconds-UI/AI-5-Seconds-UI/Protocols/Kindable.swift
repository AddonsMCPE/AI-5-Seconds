//
//	Kindable.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.08.2022.
//

import Foundation

public protocol Kindable: Reusable {
	static var kind: String { get }
}

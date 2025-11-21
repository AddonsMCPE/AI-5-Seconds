//
//	UITableView+Register.swift
//	Qibla-UI
//
//	Created by Anna Radchenko on 04.06.2022.
//

import UIKit

public extension UITableView {
	func register<T: UITableViewCell & Reusable>(_ aClass: T.Type, for identifier: String = T.reuseIdentifier) {
		if let aClass = aClass as? NibRepresentable.Type {
			register(aClass.nib, forCellReuseIdentifier: identifier)
		} else {
			register(aClass, forCellReuseIdentifier: identifier)
		}
	}
	
	func register<T: UITableViewHeaderFooterView & Reusable>(_ aClass: T.Type, for identifier: String = T.reuseIdentifier) {
		if let aClass = aClass as? NibRepresentable.Type {
			register(aClass.nib, forHeaderFooterViewReuseIdentifier: identifier)
		} else {
			register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
		}
	}
}

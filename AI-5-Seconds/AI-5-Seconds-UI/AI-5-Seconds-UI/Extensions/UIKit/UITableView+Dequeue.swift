//
//	UITableView+Dequeue.swift
//	Qibla-UI
//
//	Created by Anna Radchenko on 04.06.2022.
//

import UIKit

public extension UITableView {
	func dequeue<T: UITableViewCell & Reusable>(with identifier: String = T.reuseIdentifier, for indexPath: IndexPath) -> T {
		return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
	}
	
	func dequeue<T: UITableViewHeaderFooterView & Reusable>(with identifier: String = T.reuseIdentifier) -> T {
		return dequeueReusableHeaderFooterView(withIdentifier: identifier) as! T
	}
}

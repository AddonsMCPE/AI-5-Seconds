//
//	UICollectionView+Dequeue.swift
//	Qibla-UI
//
//	Created by Anna Radchenko on 23.05.2022.
//

import UIKit

public extension UICollectionView {
	func dequeue<T: UICollectionViewCell & Reusable>(with identifire: String = T.reuseIdentifier, for indexPath: IndexPath) -> T {
		return dequeueReusableCell(withReuseIdentifier: identifire, for: indexPath) as! T
	}
	
	func dequeue<T: UICollectionReusableView & Kindable>(ofKind kind: String = T.kind, with identifire: String = T.reuseIdentifier, for indexPath: IndexPath) -> T {
		return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifire, for: indexPath) as! T
	}
}

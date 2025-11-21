//
//	UICollectionView+Register.swift
//	Qibla-UI
//
//	Created by Anna Radchenko on 22.05.2022.
//

import UIKit

public extension UICollectionView {
	func register<T: UICollectionViewCell & Reusable>(_ aClass: T.Type, for identifier: String = T.reuseIdentifier) {
		if let aClass = aClass as? NibRepresentable.Type {
			register(aClass.nib, forCellWithReuseIdentifier: identifier)
		} else {
			register(aClass, forCellWithReuseIdentifier: identifier)
		}
	}
	
	func register<T: UICollectionReusableView & Kindable>(_ aClass: T.Type, ofKind kind: String = T.kind, for identifier: String = T.reuseIdentifier) {
		if let aClass = aClass as? NibRepresentable.Type {
			register(aClass.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
		} else {
			register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
		}
	}
}

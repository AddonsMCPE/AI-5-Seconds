//
//	NibRepresentable.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.08.2022.
//

import UIKit

public protocol NibRepresentable {
	static var bundle: Bundle { get }
	static var nibName: String { get }
}

public extension NibRepresentable where Self: AnyObject {
	static var bundle: Bundle {
		Bundle(for: self)
	}
	
	static var nibName: String {
		try! String(describing: self).substringMatches(regex: "[[:word:]]+").first!
	}
}

public extension NibRepresentable {
	static var nib: UINib {
		UINib(nibName: nibName, bundle: bundle)
	}
	
	static var canLoadNib: Bool {
		bundle.url(forResource: nibName, withExtension: "nib") != nil
	}
}

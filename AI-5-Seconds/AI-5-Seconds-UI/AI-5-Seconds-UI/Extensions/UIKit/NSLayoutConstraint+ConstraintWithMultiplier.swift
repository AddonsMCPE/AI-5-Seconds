//
//  NSLayoutConstraint+constraintWithMultiplier.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 27.02.2023.
//

import UIKit

public extension NSLayoutConstraint {
	func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
		return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
	}
}

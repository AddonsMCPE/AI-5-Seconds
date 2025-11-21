//
//	Animator.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

public protocol Animator where Self: NSObject, Self: UIViewControllerAnimatedTransitioning {
	var isPresenting: Bool { get set }
}

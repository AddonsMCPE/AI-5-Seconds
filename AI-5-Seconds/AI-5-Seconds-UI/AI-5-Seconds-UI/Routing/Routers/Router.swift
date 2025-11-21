//
//	Router.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

public protocol RouterProtocol where Self: AnyObject {
	var viewController: UIViewController? { get }
	var fromTransition: TransitionProtocol? { get }
	
	init(viewController: UIViewController?, fromTransition: TransitionProtocol?)
}

open class Router: RouterProtocol {
	public private(set) weak var viewController: UIViewController?
	public private(set) var fromTransition: TransitionProtocol?
	
	public required init(viewController: UIViewController? = nil, fromTransition: TransitionProtocol? = nil) {
		self.viewController = viewController
		self.fromTransition = fromTransition
	}
}

extension Router: CloseRoute {}
extension Router: AlertRoute {}

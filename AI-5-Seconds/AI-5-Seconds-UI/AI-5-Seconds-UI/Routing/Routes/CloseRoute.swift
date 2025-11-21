//
//	CloseRoute.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

public protocol CloseRoute where Self: RouterProtocol {
	func close(interaction: UIPercentDrivenInteractiveTransition?, completion: Transition.Completion?, animated: Bool)
}

public extension CloseRoute {
	func close(interaction: UIPercentDrivenInteractiveTransition? = nil, completion: Transition.Completion? = nil, animated: Bool = true) {
		guard let fromTransition = fromTransition else {
			fatalError("You should specify an open transition in order to close a module.")
		}
		
		guard let viewController = viewController else {
			fatalError("Nothing to close.")
		}
		
		fromTransition.interaction = interaction
		fromTransition.close(viewController, animated: animated, completion: completion)
	}
}

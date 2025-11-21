//
//  AlertTransition.swift
//  AI-Charades-UI
//
//  Created by User on 16.08.2023.
//

import UIKit

public final class AlertTransition: Transition {
	// MARK: - Inits
	
	public init(fromViewController: UIViewController?) {
		super.init(fromViewController: fromViewController, animator: FadeAnimator())
	}
	
	// MARK: - Transition methods
	
	public override func open(_ viewController: UIViewController, animated: Bool, completion: Completion?) {
		viewController.transitioningDelegate = self
		viewController.modalTransitionStyle = .coverVertical
		viewController.modalPresentationStyle = .custom
		fromViewController?.present(viewController, animated: animated, completion: completion)
	}
	
	public override func close(_ viewController: UIViewController, animated: Bool, completion: Completion?) {
		viewController.dismiss(animated: animated, completion: completion)
	}
}
	
// MARK: - UIViewControllerTransitioningDelegate

extension AlertTransition: UIViewControllerTransitioningDelegate {
	public func animationController(
		forPresented presented: UIViewController,
		presenting: UIViewController,
		source: UIViewController) -> UIViewControllerAnimatedTransitioning?
	{
		animator?.isPresenting = true
		return animator
	}
	
	public func animationController(
		forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
	{
		animator?.isPresenting = false
		return animator
	}
	
	public func presentationController(
		forPresented presented: UIViewController,
		presenting: UIViewController?,
		source: UIViewController) -> UIPresentationController?
	{
		return AlertPresentationController(presentedViewController: presented, presenting: presenting)
	}
}

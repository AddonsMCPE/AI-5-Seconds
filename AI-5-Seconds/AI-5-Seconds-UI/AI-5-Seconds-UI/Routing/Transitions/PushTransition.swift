//
//	PushTransition.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

public class PushTransition: Transition {
	// MARK: - Private properties
	
	private var direction: PushAnimatorDirection = .left
	
	// MARK: - Init

	public init(direction: PushAnimatorDirection = .left, fromViewController: UIViewController?) {
		self.direction = direction
		super.init(fromViewController: fromViewController, animator: PushAnimator(direction: direction))
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

extension PushTransition: UIViewControllerTransitioningDelegate {
	public func animationController(forPresented presented: UIViewController,
																	presenting: UIViewController,
																	source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		animator?.isPresenting = true
		return animator
	}
	
	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		animator?.isPresenting = false
		return animator
	}

	public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
		PushPresentationController(presentedViewController: presented, presenting: presenting, transition: self, direction: direction)
	}

	public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interaction
	}

	public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interaction
	}
}

//
//	SwipeTransition.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 14.08.2022.
//

import UIKit

public class SwipeTransition: Transition {
	// MARK: - Properties
	
	private var height: CGFloat
	private var isSwipeEnabled: Bool
	
	// MARK: - Init

	public init(fromViewController: UIViewController?, height: CGFloat = 506, isSwipeEnabled: Bool = false) {
		self.height = height
		self.isSwipeEnabled = isSwipeEnabled
		super.init(fromViewController: fromViewController, animator: SwipeAnimator(height: height))
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

extension SwipeTransition: UIViewControllerTransitioningDelegate {
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
		return SwipePresentationController(presentedViewController: presented, presenting: presenting, transition: self, height: height, isSwipeEnabled: isSwipeEnabled)
	}

	public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interaction
	}

	public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interaction
	}
}

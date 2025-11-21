//
//	ModalTransition.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

public extension UIModalPresentationStyle {
	static var `default`: UIModalPresentationStyle {
		if #available(iOS 13.0, *) {
			return .automatic
		} else {
			return .fullScreen
		}
	}
}

public class ModalTransition: Transition {
	// MARK: - Properties
	
	private let transitionStyle: UIModalTransitionStyle
	private let presentationStyle: UIModalPresentationStyle
	private var presentTransition: UIViewControllerAnimatedTransitioning?
	private var dismissTransition: UIViewControllerAnimatedTransitioning?
	
	// MARK: - Inits
	
	public init(fromViewController: UIViewController?, transitionStyle: UIModalTransitionStyle = .coverVertical, presentationStyle: UIModalPresentationStyle = .formSheet) {
		self.transitionStyle = transitionStyle
		self.presentationStyle = presentationStyle
		super.init(fromViewController: fromViewController)
	}
	
	public init(fromViewController: UIViewController?, transitionStyle: UIModalTransitionStyle = .crossDissolve, presentationStyle: UIModalPresentationStyle = .custom, animator: Animator) {
		self.transitionStyle = transitionStyle
		self.presentationStyle = presentationStyle
		super.init(fromViewController: fromViewController, animator: animator)
	}
	
	public override init(fromViewController: UIViewController?, animator: Animator?) {
		self.transitionStyle = .coverVertical
		self.presentationStyle = .default
		super.init(fromViewController: fromViewController, animator: animator)
	}
	
	// MARK: - Transition methods
	
	public override func open(_ viewController: UIViewController, animated: Bool, completion: Completion?) {
		viewController.transitioningDelegate = self
		viewController.modalTransitionStyle = transitionStyle
		viewController.modalPresentationStyle = presentationStyle
		fromViewController?.present(viewController, animated: animated, completion: completion)
	}
	
	public override func close(_ viewController: UIViewController, animated: Bool, completion: Completion?) {
		viewController.dismiss(animated: animated, completion: completion)
	}
}

// MARK: - UIViewControllerTransitioningDelegate

extension ModalTransition: UIViewControllerTransitioningDelegate {
	public func presentationController(forPresented presented: UIViewController,
																		 presenting: UIViewController?,
																		 source: UIViewController) -> UIPresentationController? {
		return nil
	}
	
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
}

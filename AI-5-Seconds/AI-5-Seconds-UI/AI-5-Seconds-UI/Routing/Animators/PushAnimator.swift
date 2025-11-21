//
//	PushAnimator.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

public enum PushAnimatorDirection {
	case right, left
}

public final class PushAnimator: NSObject, Animator {
	// MARK: - Public properties
	
	public var isPresenting: Bool = true
	
	// MARK: - Private properties
	
	private let duration: TimeInterval
	private let curve: CAMediaTimingFunctionName
	private let direction: PushAnimatorDirection
	
	// MARK: - Inits
	
	public init(direction: PushAnimatorDirection = .left, duration: TimeInterval = 0.2, curve: CAMediaTimingFunctionName = .easeInEaseOut) {
		self.direction = direction
		self.duration = duration
		self.curve = curve
	}
	
	// MARK: - UIViewControllerAnimatedTransitioning
	
	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		if let fromView = transitionContext.view(forKey: .from) {
			let containerView = transitionContext.containerView

			containerView.addSubview(fromView)
			fromView.frame.origin = .zero

			UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
				switch self.direction {
				case .right:
					fromView.frame.origin = CGPoint(x: -fromView.frame.width, y: 0)
				case .left:
					fromView.frame.origin = CGPoint(x: fromView.frame.width, y: 0)
				}
			}, completion: { _ in
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			})
		}

		if let toView = transitionContext.view(forKey: .to) {
			let containerView = transitionContext.containerView
			containerView.addSubview(toView)
			toView.frame = containerView.frame
			switch self.direction {
			case .right:
				toView.frame.origin = CGPoint(x: -containerView.frame.width, y: 0)
			case .left:
				toView.frame.origin = CGPoint(x: containerView.frame.width, y: 0)
			}
			UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
				toView.frame.origin = CGPoint(x: 0, y: 0)
			}, completion: { _ in
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			})
		}
	}
}

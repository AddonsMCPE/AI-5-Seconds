//
//	SwipeAnimator.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 14.08.2022.
//

import UIKit

public final class SwipeAnimator: NSObject, Animator {
	// MARK: - Public properties
	
	public var isPresenting: Bool = true
	private var height: CGFloat
	private let duration: TimeInterval
	
	// MARK: - Inits
	
	public init(height: CGFloat, duration: TimeInterval = 0.3) {
		self.height = height
		self.duration = duration
		super.init()
	}
	
	// MARK: - UIViewControllerAnimatedTransitioning
	
	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let inView = transitionContext.containerView
		let toView = transitionContext.viewController(forKey: .to)!.view!
		let fromView = transitionContext.viewController(forKey: .from)!.view!

		let frame = inView.bounds

		var offToBottom = frame
		offToBottom.size.height = height
		offToBottom.origin.y += offToBottom.size.height

		if isPresenting {
			toView.frame = offToBottom

			inView.addSubview(toView)
			UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
				var onScreen = offToBottom
				onScreen.origin.y -= offToBottom.size.height
				toView.frame = onScreen
			}, completion: { finished in
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			})
		} else {
			UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
				var onScreen = offToBottom
				onScreen.origin.y = inView.bounds.height
				fromView.frame = onScreen
			}, completion: { finished in
				transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
			})
		}
	}
}

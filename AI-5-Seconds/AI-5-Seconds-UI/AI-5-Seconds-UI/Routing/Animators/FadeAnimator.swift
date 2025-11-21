//
//	FadeAnimator.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

public final class FadeAnimator: NSObject, Animator {
	// MARK: - Public properties
	
	public var isPresenting: Bool = true
	
	// MARK: - Private properties
	
	private let duration: TimeInterval
	private let options: UIView.AnimationOptions
	private var toView: UIView?
	
	// MARK: - Inits
	
	public init(duration: TimeInterval = 0.3, options: UIView.AnimationOptions = .curveEaseOut) {
		self.duration = duration
		self.options = options
	}
	
	// MARK: - UIViewControllerAnimatedTransitioning
	
	public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		var toView = UIView()
		var fromView = UIView()
		if isPresenting {
			guard let _toView = transitionContext.view(forKey: .to) else { return }
			toView = _toView
			self.toView = _toView
		} else {
			guard let _fromView = transitionContext.view(forKey: .from), let _toView = self.toView else { return }
			toView = _toView
			fromView = _fromView
		}
		
		let container = transitionContext.containerView
		if isPresenting {
			container.addSubview(toView)
			toView.alpha = 0.0
		} else {
			container.insertSubview(toView, belowSubview: fromView)
		}
		
		UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
			if self.isPresenting {
				toView.alpha = 1.0
			} else {
				fromView.alpha = 0.0
			}
		}, completion: { _ in
			let success = !transitionContext.transitionWasCancelled
			if !success {
				toView.removeFromSuperview()
			}
			transitionContext.completeTransition(success)
		})
	}
}

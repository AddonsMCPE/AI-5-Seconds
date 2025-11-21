//
//	PushPresentationController.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

final class PushPresentationController: UIPresentationController {
	// MARK: - Private properties
	
	private var transition: TransitionProtocol
	private var interaction: UIPercentDrivenInteractiveTransition?
	private var direction: PushAnimatorDirection
	
	// MARK: - Inits
	
	init(presentedViewController: UIViewController,
			 presenting presentingViewController: UIViewController?,
			 transition: TransitionProtocol,
			 direction: PushAnimatorDirection) {
		self.transition = transition
		self.direction = direction
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
	}
	
	// MARK: - Actions
	
	@objc private func handleSwipe(_ gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: presentedViewController.view)
		
		var percent = translation.x / presentedViewController.view.bounds.size.width
		if direction == .right {
			percent = -translation.x / presentedViewController.view.bounds.size.width
		}
		
		switch gesture.state {
		case .began:
			interaction = UIPercentDrivenInteractiveTransition()
			transition.interaction = interaction
			transition.close(presentedViewController, animated: true, completion: nil)
		case .changed:
			interaction?.update(percent)
		case .ended where percent >= 0.3:
			interaction?.finish()
			interaction = nil
		case .cancelled, .ended where percent < 0.3:
			interaction?.cancel()
			interaction = nil
		default:
			break
		}
	}
	
	// MARK: - Override properties
	
	override var frameOfPresentedViewInContainerView: CGRect {
		let maxSize = (containerView?.bounds ?? .zero).size
		let origin = CGPoint(x: 0, y: 0)
		return .init(origin: origin, size: maxSize)
	}
	
	// MARK: - Overrise methods
	
	override func containerViewWillLayoutSubviews() {
		super.containerViewWillLayoutSubviews()
		presentedViewController.view.frame = frameOfPresentedViewInContainerView
	}
	
	override func presentationTransitionWillBegin() {
		containerView?.backgroundColor = UIColor.black.withAlphaComponent(0)
		
		presentedView?.frame = frameOfPresentedViewInContainerView
		containerView?.addSubview(presentedViewController.view)
		
		presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
			self.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
		}, completion: nil)
	}
	
	override func presentationTransitionDidEnd(_ completed: Bool) {
		super.presentationTransitionDidEnd(completed)
		
		let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
		edgePan.edges = direction == .left ? .left : .right
		presentedViewController.view.addGestureRecognizer(edgePan)
	}
	
	override func dismissalTransitionWillBegin() {
		presentingViewController.transitionCoordinator?.animateAlongsideTransition(in: presentingViewController.view, animation: { _ in
			self.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0)
		}, completion: nil)
	}
	
	override func dismissalTransitionDidEnd(_ completed: Bool) {
		super.dismissalTransitionDidEnd(completed)
	}
}

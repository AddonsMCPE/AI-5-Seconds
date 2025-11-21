//
//	DarkerPresentationController.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 11.12.2022.
//

import UIKit

class DarkerPresentationController: UIPresentationController {
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
			self.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		}, completion: nil)
	}
	
	override func presentationTransitionDidEnd(_ completed: Bool) {
		super.presentationTransitionDidEnd(completed)
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

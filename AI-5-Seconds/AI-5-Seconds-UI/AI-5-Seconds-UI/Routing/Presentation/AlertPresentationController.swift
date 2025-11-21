//
//  AlertPresentationController.swift
//  AI-Charades-UI
//
//  Created by User on 16.08.2023.
//

import UIKit

final class AlertPresentationController: UIPresentationController {
	// MARK: - Private properties
	
	private var dimmingView: UIView!
	
	// MARK: - Override properties
	
	override var shouldRemovePresentersView: Bool {
		return false
	}
	
	override var frameOfPresentedViewInContainerView: CGRect {
		let maxSize = (containerView?.bounds ?? .zero).size
		let size = presentedView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize) ?? .zero
		let origin = CGPoint(
			x: (maxSize.width - size.width) / 2,
			y: (maxSize.height - size.height) / 2
		)
		return .init(origin: origin, size: size)
	}
	
	// MARK: - Overrise methods
	
	override func containerViewWillLayoutSubviews() {
		super.containerViewWillLayoutSubviews()
		
		presentedViewController.view.frame = frameOfPresentedViewInContainerView
		dimmingView.frame = containerView?.bounds ?? .zero
	}
	
	override func presentationTransitionWillBegin() {
		dimmingView = UIView()
		dimmingView.backgroundColor = .colorBlack.withAlphaComponent(0.4)
		dimmingView.alpha = 0
		dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		containerView?.insertSubview(dimmingView, at: 0)
		containerView?.backgroundColor = .clear
		
		presentedView?.frame = frameOfPresentedViewInContainerView
		containerView?.addSubview(presentedViewController.view)
		
		presentedViewController.view.clipsToBounds = true
		presentedViewController.view.layer.cornerRadius = 24
		presentedViewController.view.layer.borderColor = UIColor.colorWhite.withAlphaComponent(0.2).cgColor
		presentedViewController.view.layer.borderWidth = 2
		
		presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
			self.dimmingView.alpha = 1
		}, completion: nil)
	}
	
	override func presentationTransitionDidEnd(_ completed: Bool) {
		super.presentationTransitionDidEnd(completed)
	}
	
	override func dismissalTransitionWillBegin() {
		presentingViewController.transitionCoordinator?.animateAlongsideTransition(in: presentingViewController.view, animation: { _ in
			self.dimmingView.alpha = 0
		}, completion: nil)
	}
	
	override func dismissalTransitionDidEnd(_ completed: Bool) {
		super.dismissalTransitionDidEnd(completed)
	}
}

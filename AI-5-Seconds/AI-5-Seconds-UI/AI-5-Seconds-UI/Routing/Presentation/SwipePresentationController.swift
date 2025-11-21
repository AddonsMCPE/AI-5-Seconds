//
//	SwipePresentationController.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 14.08.2022.
//

import UIKit

final class SwipePresentationController: UIPresentationController {
	// MARK: - Private properties
	
	private var transition: TransitionProtocol
	private var interaction: UIPercentDrivenInteractiveTransition?
	private var height: CGFloat
	private var dimmingView: UIControl!
	private var isSwipeEnabled: Bool
	
	// MARK: - Inits
	
	init(presentedViewController: UIViewController,
			 presenting presentingViewController: UIViewController?,
			 transition: TransitionProtocol,
			 height: CGFloat,
			 isSwipeEnabled: Bool) {
		self.transition = transition
		self.height = height
		self.isSwipeEnabled = isSwipeEnabled
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
	}
	
	// MARK: - Actions
	
	@objc func dismiss() {
		transition.interaction = nil
		transition.close(presentedViewController, animated: true, completion: nil)
	}
	
	@objc private func handleSwipe(_ gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: presentedViewController.view)
		
		let percent = translation.y / height
		
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
		var maxSize = (containerView?.bounds ?? .zero).size
		let origin = CGPoint(x: 0, y: maxSize.height - height)
		maxSize.height = height
		return .init(origin: origin, size: maxSize)
	}
	
	// MARK: - Overrise methods
	
	override func containerViewWillLayoutSubviews() {
		super.containerViewWillLayoutSubviews()
		presentedViewController.view.frame = frameOfPresentedViewInContainerView
		presentedViewController.view.layer.cornerRadius = 24
		presentedViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		presentedViewController.view.clipsToBounds = true
		dimmingView.frame = containerView?.bounds ?? .zero
	}
	
	override func presentationTransitionWillBegin() {
		dimmingView = UIControl(frame: containerView!.bounds)
		dimmingView.backgroundColor = .clear
		dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		dimmingView.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
		containerView?.addSubview(dimmingView)
		containerView?.backgroundColor = UIColor.black.withAlphaComponent(0)
		
		presentedView?.frame = frameOfPresentedViewInContainerView
		containerView?.addSubview(presentedViewController.view)
		
		presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
			self.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
		}, completion: nil)
	}
	
	override func presentationTransitionDidEnd(_ completed: Bool) {
		super.presentationTransitionDidEnd(completed)
		
		if isSwipeEnabled {
			let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
			presentedViewController.view.addGestureRecognizer(panGesture)
		}
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

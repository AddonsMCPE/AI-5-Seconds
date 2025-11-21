//
//  ChildTransition.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 02.05.2023.
//

import UIKit
import ObjectiveC

public final class _HostTransitionState: NSObject {
	public weak var currentChild: UIViewController?
	public weak var containerView: UIView?
}

private var _hostKey: UInt8 = 0

public extension UIViewController {
	var _childTransitionState: _HostTransitionState {
		if let s = objc_getAssociatedObject(self, &_hostKey) as? _HostTransitionState { return s }
		let s = _HostTransitionState()
		s.containerView = self.view
		objc_setAssociatedObject(self, &_hostKey, s, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		return s
	}
}

public final class ChildTransition: Transition {
	
	public enum FirstAppearStyle { case coverVertical, crossDissolve }
	public enum FinalDismissStyle { case coverVerticalDown, crossDissolve }
	
	public var firstAppearStyle: FirstAppearStyle = .coverVertical
	public var finalDismissStyle: FinalDismissStyle = .coverVerticalDown
	
	public var firstAppearDuration: TimeInterval = 0.25
	public var swapFadeDuration: TimeInterval = 0.22
	public var finalDismissDuration: TimeInterval = 0.25
	public var animationOptions: UIView.AnimationOptions = [.curveEaseInOut, .beginFromCurrentState]
	
	public weak var containerView: UIView? {
		didSet { fromViewController?._childTransitionState.containerView = containerView ?? fromViewController?.view }
	}
	
	public override init(fromViewController: UIViewController?, animator: Animator? = nil) {
		super.init(fromViewController: fromViewController, animator: animator)
		if let host = fromViewController, host._childTransitionState.containerView == nil {
			host._childTransitionState.containerView = host.view
		}
	}
	
	// MARK: TransitionProtocol
	
	public override func setInitial(_ viewCintroller: UIViewController) {
		guard let host = fromViewController else { return }
		let st = host._childTransitionState
		let container = (containerView ?? st.containerView ?? host.view)!
		host.addChild(viewCintroller)
		pin(viewCintroller.view, to: container)
		viewCintroller.view.alpha = 1
		viewCintroller.view.transform = .identity
		viewCintroller.didMove(toParent: host)
		st.currentChild = viewCintroller
	}
	
	public override func open(_ viewController: UIViewController, animated: Bool, completion: Completion?) {
		guard let host = fromViewController else { completion?(); return }
		let st = host._childTransitionState
		let container = (containerView ?? st.containerView ?? host.view)!
		
		if let current = st.currentChild, current !== viewController {
			swap(from: current, to: viewController, host: host, container: container, animated: animated, completion: completion)
		} else if st.currentChild == nil {
			presentFirst(viewController, host: host, container: container, animated: animated, completion: completion)
		} else {
			completion?()
		}
	}
	
	public override func close(_ viewController: UIViewController, animated: Bool, completion: Completion?) {
		guard let host = fromViewController else { completion?(); return }
		let st = host._childTransitionState
		guard let current = st.currentChild, current === viewController else { completion?(); return }
		dismissLast(current, host: host, animated: animated, completion: completion)
	}
	
	// MARK: - Private methods
	
	private func presentFirst(
		_ child: UIViewController,
		host: UIViewController,
		container: UIView,
		animated: Bool,
		completion: Completion?
	) {
		host.addChild(child)
		pin(child.view, to: container)
		
		let duration = animated ? firstAppearDuration : 0
		
		switch firstAppearStyle {
		case .coverVertical:
			child.view.alpha = 1
			child.view.transform = CGAffineTransform(translationX: 0, y: container.bounds.height)
			UIView.animate(withDuration: duration, delay: 0, options: animationOptions) {
				child.view.transform = .identity
			} completion: { _ in
				child.didMove(toParent: host)
				host._childTransitionState.currentChild = child
				completion?()
			}
			
		case .crossDissolve:
			child.view.alpha = 0
			child.view.transform = .identity
			UIView.animate(withDuration: duration, delay: 0, options: animationOptions) {
				child.view.alpha = 1
			} completion: { _ in
				child.didMove(toParent: host)
				host._childTransitionState.currentChild = child
				completion?()
			}
		}
	}
	
	private func swap(
		from old: UIViewController,
		to new: UIViewController,
		host: UIViewController,
		container: UIView,
		animated: Bool,
		completion: Completion?
	) {
		host.addChild(new)
		pin(new.view, to: container)
		new.view.alpha = 0
		new.view.transform = .identity
		
		UIView.animate(withDuration: animated ? swapFadeDuration : 0, delay: 0, options: animationOptions) {
			//old.view.alpha = 0
			new.view.alpha = 1
		} completion: { _ in
			old.willMove(toParent: nil)
			old.view.removeFromSuperview()
			old.removeFromParent()
			new.didMove(toParent: host)
			host._childTransitionState.currentChild = new
			completion?()
		}
	}
	
	private func dismissLast(
		_ child: UIViewController,
		host: UIViewController,
		animated: Bool,
		completion: Completion?
	) {
		let duration = animated ? finalDismissDuration : 0
		
		switch finalDismissStyle {
		case .coverVerticalDown:
			let targetY = child.view.bounds.height
			UIView.animate(withDuration: duration, delay: 0, options: animationOptions) {
				child.view.transform = CGAffineTransform(translationX: 0, y: targetY)
			} completion: { _ in
				self.cleanup(child: child, host: host)
				completion?()
			}
			
		case .crossDissolve:
			UIView.animate(withDuration: duration, delay: 0, options: animationOptions) {
				child.view.alpha = 0
			} completion: { _ in
				self.cleanup(child: child, host: host)
				completion?()
			}
		}
	}
	
	private func cleanup(
		child: UIViewController,
		host: UIViewController
	) {
		child.willMove(toParent: nil)
		child.view.removeFromSuperview()
		child.removeFromParent()
		host._childTransitionState.currentChild = nil
	}
	
	private func pin(
		_ v: UIView,
		to container: UIView
	) {
		v.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(v)
		NSLayoutConstraint.activate([
			v.topAnchor.constraint(equalTo: container.topAnchor),
			v.leadingAnchor.constraint(equalTo: container.leadingAnchor),
			v.trailingAnchor.constraint(equalTo: container.trailingAnchor),
			v.bottomAnchor.constraint(equalTo: container.bottomAnchor)
		])
	}
}

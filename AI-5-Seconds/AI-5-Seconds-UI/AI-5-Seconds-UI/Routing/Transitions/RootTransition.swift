//
//	RootTransition.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

public final class RootTransition: TransitionProtocol {
	// MARK: - Public properties
	
	public var interaction: UIPercentDrivenInteractiveTransition?
	
	// MARK: - Private properties
	
	private weak var window: UIWindow?
	private let options: UIView.AnimationOptions
	private let duration: TimeInterval
	
	// MARK: - Inits
	
	public init(window: UIWindow, options: UIView.AnimationOptions = .transitionCrossDissolve, duration: TimeInterval = 0.3) {
		self.window = window
		self.options = options
		self.duration = duration
	}
	
	// MARK: - Transition methods
	
	public func open(_ viewController: UIViewController, animated: Bool, completion: Completion?) {
		guard let window = window else { return }
		window.rootViewController = viewController
		window.makeKeyAndVisible()
		if animated {
			UIView.transition(with: window, duration: duration, options: options, animations: nil) { _ in completion?() }
		}
	}
	
	@available(*, deprecated)
	public func close(_ viewController: UIViewController, animated: Bool, completion: Completion?) {
		fatalError()
	}
	
	@available(*, deprecated)
	public func setInitial(_ viewCintroller: UIViewController) {
		fatalError()
	}
}

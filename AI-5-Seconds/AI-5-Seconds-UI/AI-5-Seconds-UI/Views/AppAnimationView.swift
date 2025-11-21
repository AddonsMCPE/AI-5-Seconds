//
//  AppAnimationView.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 22.02.2023.
//

import UIKit
import Lottie

final public class AppAnimationView: UIView {
	// MARK: - Properties

	private var animationView: AnimationView?
	private var animationName: String?
	
	// MARK: - Inits
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
	}
	
	// MARK: - Lifecycle
	
	public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		
		initAnimationView(name: animationName)
	}
	
	// MARK: - Private methods
	
	public func play() {
		animationView?.play()
	}
	
	public func stop() {
		animationView?.stop()
	}
	
	public func initAnimationView(name: String?) {
		guard let name = name else { return }
		animationName = name
		animationView?.removeFromSuperview()
		animationView = AnimationView(name: name, bundle: .uiBundle)
		animationView?.contentMode = .scaleToFill
		animationView?.backgroundBehavior = .pauseAndRestore

		if let animationView = self.animationView {
			self.add(animationView)
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(appIsActivited), name: UIApplication.didBecomeActiveNotification, object: nil)
	}
	
	// MARK: - Private methods
	
	@objc private func appIsActivited() {
		initAnimationView(name: animationName)
	}
	
	private func add(_ animationView: AnimationView) {
		addSubview(animationView)
		
		animationView.translatesAutoresizingMaskIntoConstraints = false
		animationView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		animationView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		animationView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		animationView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		
		animationView.loopMode = .loop
		animationView.play()
	}
}

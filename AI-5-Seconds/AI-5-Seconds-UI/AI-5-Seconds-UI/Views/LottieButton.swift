//
//  LottieButton.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 09.08.2022.
//

import UIKit
import Lottie

open class LottieButton: BadgeButton {
  // MARK: - Properties

	public private(set) var animationView: AnimationView?

	public var animationName: String?
	public var animationContentMode: UIView.ContentMode = .scaleAspectFill
	
	public func setAnimation(with name: String) {
		animationName = name
		animationView?.removeFromSuperview()
		animationView = AnimationView(name: name, bundle: Bundle.uiBundle)
		animationView?.backgroundBehavior = .pauseAndRestore

		if let animationView = animationView {
			add(animationView)
		}
	}
	
	public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		animationView?.play()
	}
		
	public override func layoutSubviews() {
		super.layoutSubviews()
		animationView?.play()
	}
	
  // MARK: - Private methods

  open func add(_ animationView: AnimationView) {
		self.imageView?.addSubview(animationView)
		
		self.imageView?.translatesAutoresizingMaskIntoConstraints = false
		self.imageView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		self.imageView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		self.imageView?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		self.imageView?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		
		animationView.translatesAutoresizingMaskIntoConstraints = false
		animationView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
		animationView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
		animationView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2).isActive = true
		animationView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
		
		animationView.contentMode = animationContentMode
		animationView.loopMode = .loop
		animationView.play()
  }
}

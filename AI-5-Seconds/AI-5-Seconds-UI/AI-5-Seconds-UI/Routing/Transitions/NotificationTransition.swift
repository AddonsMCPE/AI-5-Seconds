//
//  NotificationTransition.swift
//  AI-Charades-UI
//
//  Created by User on 17.08.2023.
//

import UIKit

public final class NotificationTransition: Transition {
	// MARK: - Private preperties
	
	private var completion: Transition.Completion?
	private var initialFrame: CGRect = .zero
	private var notificationAlertController: UIViewController?
	private var isGestured: Bool = false
	
	// MARK: - Transition methods
	
	public override func open(_ controller: UIViewController, animated: Bool, completion: Transition.Completion?) {
		self.completion = completion
		notificationAlertController = controller
		notificationAlertController?.view.clipsToBounds = true
		notificationAlertController?.view.layer.cornerRadius = 16
		notificationAlertController?.view.layer.borderWidth = 2
		notificationAlertController?.view.layer.borderColor = UIColor.colorWhite.withAlphaComponent(0.2).cgColor
		add(controller)
	}
	
	public override func close(_ controller: UIViewController, animated: Bool, completion: Transition.Completion?) {
		self.completion = completion
		remove(controller)
	}
	
	private func add(_ notificationAlertController: UIViewController) {
		guard let fromViewController = UIWindow.appWindow else { return }
		
		let width: CGFloat = 355
		
		initialFrame = CGRect(
			x: (fromViewController.frame.width - width) / 2,
			y: fromViewController.safeAreaInsets.top,
			width: width,
			height: 62)
		notificationAlertController.view.frame = initialFrame
		
		fromViewController.addSubview(notificationAlertController.view)
		
		notificationAlertController.view.transform = CGAffineTransform(translationX: 0, y: -fromViewController.frame.height)
		
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
			notificationAlertController.view.transform = CGAffineTransform(translationX: 0, y: 0)
		}, completion: { _ in
			let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
			notificationAlertController.view.addGestureRecognizer(panGesture)
		})
	}

	private func remove(_ controller: UIViewController, duration: TimeInterval = 0.3) {
		UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
			controller.view.transform = CGAffineTransform(translationX: 0, y: -(UIWindow.appWindow?.safeAreaInsets.top ?? 0) - controller.view.frame.height)
		}, completion: { _ in
			controller.view.removeFromSuperview()
		})
	}
	
	// MARK: - Actions
	
	@objc private func handleSwipe(_ gesture: UIPanGestureRecognizer) {
		if isGestured {
			return
		} else {
			isGestured = true
		}
		guard let controller = notificationAlertController else { return }
		remove(controller, duration: 0.3)
		notificationAlertController = nil
	}
}

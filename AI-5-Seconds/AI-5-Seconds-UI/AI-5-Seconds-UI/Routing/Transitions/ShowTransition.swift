//
//	ShowTransition.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

public final class ShowTransition: Transition {
	// MARK: - Private preperties
	
	private var completion: Transition.Completion?
	
	// MARK: - Transition methods
	
	public override func open(_ controller: UIViewController, animated: Bool, completion: Transition.Completion?) {
		self.completion = completion
		fromViewController?.splitViewController?.delegate = self
		fromViewController?.splitViewController?.showDetailViewController(controller, sender: self)
	}
	
	public override func close(_ controller: UIViewController, animated: Bool, completion: Transition.Completion?) {
		self.completion = completion
		fromViewController?.navigationController?.popViewController(animated: true)
	}
	
	public override func setInitial(_ controller: UIViewController) {
		if fromViewController?.splitViewController?.viewControllers.count == 2 {
			fromViewController?.splitViewController?.viewControllers[1] = controller
		}
	}
}

// MARK: - UINavigationControllerDelegate

extension ShowTransition: UISplitViewControllerDelegate {
	public func splitViewController(_ svc: UISplitViewController, willShow aViewController: UIViewController, invalidating barButtonItem: UIBarButtonItem) {
		completion?()
	}
}

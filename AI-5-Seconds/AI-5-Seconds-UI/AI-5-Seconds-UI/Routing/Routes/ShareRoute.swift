//
//	ShareRoute.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

public protocol ShareRoute where Self: RouterProtocol {
	func openShare(_ texts: [String], completion: Transition.Completion?)
	func openShare(fileURL: URL, completion: Transition.Completion?)
	func openShare(_ image: UIImage, completion: Transition.Completion?)
	func openShare(videoURL: URL, completion: Transition.Completion?)
}

public extension ShareRoute {
	func openShare(_ texts: [String], completion: Transition.Completion?) {
		let textShare = texts
		let appLink = URL(string: .appURL)!
		var textToShare: [Any] = [
			MyActivityItemSource(title: .appName, text: textShare.joined(separator: "\n"), link: appLink)
		]
		let activityViewController = UIActivityViewController(activityItems: textToShare , applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = viewController?.view
		activityViewController.popoverPresentationController?.sourceRect = CGRect(x: viewController!.view.bounds.midX, y: viewController!.view.bounds.maxY, width: 0, height: 0)
		
		let transition = ModalTransition(fromViewController: viewController)
		transition.open(activityViewController, animated: true, completion: completion)
	}
	
	func openShare(fileURL: URL, completion: Transition.Completion?) {
		let urlToShare: [Any] = [fileURL]
		
		let activityViewController = UIActivityViewController(activityItems: urlToShare, applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = viewController?.view
		
		activityViewController.popoverPresentationController?.sourceRect = CGRect(x: viewController!.view.bounds.midX, y: viewController!.view.bounds.maxY, width: 0, height: 0)
		
		let transition = ModalTransition(fromViewController: viewController)
		transition.open(activityViewController, animated: true, completion: completion)
	}
	
	func openShare(_ image: UIImage, completion: Transition.Completion?) {
		let appLink = URL(string: .appURL)!
		var itemsToShare: [Any] = [
			image,
			appLink
		]
		
		let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = viewController?.view
		activityViewController.popoverPresentationController?.sourceRect = CGRect(x: viewController!.view.bounds.midX, y: viewController!.view.bounds.maxY, width: 0, height: 0)
		
		let transition = ModalTransition(fromViewController: viewController)
		transition.open(activityViewController, animated: true, completion: completion)
	}
	
	func openShare(videoURL: URL, completion: Transition.Completion?) {
		let appLink = URL(string: .appURL)!
		let textToShare: [Any] = [
			MyActivityItemSource(title: .appName, text: "", link: appLink),
			videoURL
		]
		
		let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = viewController?.view
		
		let transition = ModalTransition(fromViewController: viewController)
		transition.open(activityViewController, animated: true, completion: completion)
	}
}

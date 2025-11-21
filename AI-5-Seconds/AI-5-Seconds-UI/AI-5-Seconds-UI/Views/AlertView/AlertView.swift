//
//  AlertView.swift
//  AI-Charades-UI
//
//  Created by User on 16.08.2023.
//

import UIKit

final class AlertView: UIView {
	// MARK: - Outlets
	
	@IBOutlet private var containerView: UIView! {
		didSet {
			containerView.backgroundColor = .clear
		}
	}
	
	@IBOutlet private var mainView: UIView! {
		didSet {
			mainView.backgroundColor = .clear
		}
	}
	
	@IBOutlet private var titleLabel: UILabel! {
		didSet {
			titleLabel.text = nil
			titleLabel.font = .extrabold20
			titleLabel.textColor = .textPrimary
		}
	}
	
	@IBOutlet private var messageLabel: UILabel! {
		didSet {
			messageLabel.text = nil
			messageLabel.font = .medium20
			messageLabel.textColor = .textPrimary
		}
	}
	
	@IBOutlet private(set) var buttonStackView: UIStackView!
	
	// MARK: - Properties
	
	var title: String? {
		get { return titleLabel.text }
		set {
			titleLabel.text = newValue
			titleLabel.isHidden = newValue == nil
		}
	}
	
	var message: String? {
		get { return messageLabel.text }
		set {
			messageLabel.text = newValue
			messageLabel.isHidden = newValue == nil
		}
	}
}

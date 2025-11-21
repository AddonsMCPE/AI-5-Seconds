//
//  NotificationAlertView.swift
//  AI-Charades-UI
//
//  Created by User on 16.08.2023.
//

import UIKit

public final class NotificationAlertView: UIView {
	// MARK: - Outlets
	
	@IBOutlet private var mainView: UIView! {
		didSet {
			//mainView.clipsToBounds = true
			//mainView.layer.cornerRadius = 12
			mainView.backgroundColor = .clear
		}
	}
	
	@IBOutlet private var bgImageView: UIImageView! {
		didSet {
			bgImageView.image = UIImage()
		}
	}
	
	@IBOutlet private var titleLabel: UILabel! {
		didSet {
			titleLabel.text = nil
			titleLabel.font = .medium16
			titleLabel.numberOfLines = 0
			titleLabel.adjustsFontSizeToFitWidth = true
			titleLabel.minimumScaleFactor = 0.5
			titleLabel.textColor = .colorWhite
		}
	}
	
	@IBOutlet private var closeButton: IconButton! {
		didSet {
			closeButton.tintColor = .colorWhite
			closeButton.setTitle("", for: .normal)
			closeButton.setImage(.iconClose, for: .normal)
			closeButton.addAction(for: .touchUpInside, action: { _ in
				self.closeButtonAction?()
			})
		}
	}
	
	// MARK: - Properties
	
	var title: String? {
		get { return titleLabel.text }
		set {
			titleLabel.text = newValue
			titleLabel.isHidden = newValue == nil
		}
	}
	var style: NotificationAlertStyle = .default {
		didSet {
			switch style {
			case .default:
				mainView.backgroundColor = .colorGreen
				bgImageView.backgroundColor = .clear
				bgImageView.image = UIImage()
				closeButton.setImage(.iconClose, for: .normal)
			case .destructive:
				mainView.backgroundColor = .colorRed
				bgImageView.backgroundColor = .clear
				bgImageView.image = UIImage()
				closeButton.setImage(.iconClose, for: .normal)
			case .attention:
				mainView.backgroundColor = .colorYellow
				bgImageView.backgroundColor = .clear
				bgImageView.image = UIImage()
				closeButton.setImage(.iconClose, for: .normal)
			}
		}
	}
	var closeButtonAction: (()->Void)?
}

//
//  IconButton.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 01.03.2023.
//

import UIKit

public final class IconButton: UIButton {
	// MARK: - Public methods
	
	public func setIconImage(_ icon: UIImage, _ title: String, font: UIFont = .medium16, imagePadding: CGFloat = 10, for state: UIControl.State) {
		setTitle(title, for: state)
		setTitleColor(.textPrimary, for: state)
		tintColor = .textPrimary
		if #available(iOS 15.0, *) {
			var configuration = UIButton.Configuration.plain()
			configuration.titlePadding = 10
			
			configuration.image = icon
			configuration.imagePadding = imagePadding
			
			configuration.cornerStyle = .capsule
			configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
				var outgoing = incoming
				outgoing.font = font
				return outgoing
			}
			self.configuration = configuration
		} else {
			titleLabel?.font = font
			setImage(icon, for: state)
			imageView?.contentMode = .scaleAspectFit
			imageEdgeInsets = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 0)
			titleEdgeInsets = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 20)
		}
		layoutIfNeeded()
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
	}
}

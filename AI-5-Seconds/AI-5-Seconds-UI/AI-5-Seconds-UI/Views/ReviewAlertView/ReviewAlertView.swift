//
//  ReviewAlertView.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 19.09.2024.
//

import UIKit

final class ReviewAlertView: UIView {
	// MARK: - Outlets
	
	@IBOutlet private var mainView: UIView! {
		didSet {
			mainView.backgroundColor = .colorBlue
		}
	}
	
	@IBOutlet private var titleLabel: UILabel! {
		didSet {
			titleLabel.setStyle(textColor: .textPrimary, font: .black28, numberOfLines: 3, textAlignment: .center, isScaleEnabled: false)
			titleLabel.text = LS.Common.Label.doYouLikeOurApp.localized
			//titleLabel.setStrokedText(LS.Common.Label.doYouLikeOurApp.localized)
			shadowInstall(
				for: titleLabel,
				shadowColor: UIColor.colorBlack.withAlphaComponent(0.4).cgColor,
				shadowOpacity: 1,
				shadowOffset: CGSize(width: 2, height: 2),
				shadowRadius: 0
			)
		}
	}
	
	@IBOutlet private var bgImage: UIImageView! {
		didSet {
			bgImage.image = .imageReviewTitle
		}
	}
	
	@IBOutlet private var noButton: UIButton! {
		didSet {
			noButton.clipsToBounds = true
			noButton.layer.cornerRadius = 16
			noButton.layer.borderWidth = 2
			noButton.layer.borderColor = UIColor.colorWhite.withAlphaComponent(0.2).cgColor
			noButton.backgroundColor = .colorRed
			noButton.setTitleColor(.colorWhite, for: .normal)
			noButton.setTitle(LS.Minor.Label.later.localized, for: .normal)
			noButton.titleLabel?.font = .extrabold20
			noButton.addAction(for: .touchUpInside, action: { _ in
				self.noButtonAction?()
			})
		}
	}
	
	@IBOutlet private var yesButton: UIButton! {
		didSet {
			yesButton.clipsToBounds = true
			yesButton.layer.cornerRadius = 16
			yesButton.layer.borderWidth = 2
			yesButton.layer.borderColor = UIColor.colorWhite.withAlphaComponent(0.2).cgColor
			yesButton.backgroundColor = .colorGreen
			yesButton.setTitleColor(.colorWhite, for: .normal)
			yesButton.setTitle(LS.Minor.Label.yes.localized, for: .normal)
			yesButton.titleLabel?.font = .extrabold20
			yesButton.addAction(for: .touchUpInside, action: { _ in
				self.yesButtonAction?()
			})
		}
	}
	
	// MARK: - Properties
	
	var noButtonAction: (()->())?
	var yesButtonAction: (()->())?
}

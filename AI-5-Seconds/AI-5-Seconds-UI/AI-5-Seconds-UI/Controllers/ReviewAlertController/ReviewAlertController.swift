//
//  ReviewAlertController.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 19.09.2024.
//

import UIKit

final class ReviewAlertController: ViewController<ReviewAlertView, ReviewAlertRouter> {
	// MARK: - Properties
	
	override var bgColor: UIColor! {
		return .white.withAlphaComponent(0.4)
	}
	
	// MARK: - Inits
	
	override init() {
		super.init()
		// исключение для алерт и экшн котроллеров для создания вью во время инициализации
		_ = view
		mainView.noButtonAction = { [weak self] in
			guard let self else { return }
			self.router.close()
		}
		mainView.yesButtonAction = { [weak self] in
			guard let self else { return }
			UserDefaults.isReviewAlertShowed = true
			self.router.close()
			self.router.toReview()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func premiumDidChange() {}
}

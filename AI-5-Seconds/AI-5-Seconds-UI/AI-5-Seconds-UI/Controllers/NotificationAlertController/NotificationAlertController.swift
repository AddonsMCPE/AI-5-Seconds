//
//  NotificationController.swift
//  AI-Charades-UI
//
//  Created by User on 16.08.2023.
//

import UIKit

public enum NotificationAlertStyle {
	case `default`, destructive, attention
}

public final class NotificationAlertController: ViewController<NotificationAlertView, NotificationAlertRouter> {
	// MARK: - Properties
	
	public override var bgColor: UIColor! {
		return .colorGreen
	}
	private var closeTimer = Timer()
	
	// MARK: - Inits
	
	public init(title: String?, style: NotificationAlertStyle) {
		super.init()
		// исключение для алерт и экшн котроллеров для создания вью во время инициализации
		_ = view
		mainView.title = title
		mainView.style = style
		mainView.closeButtonAction = { [weak self] in
			guard let self else { return }
			self.router.close()
		}
		closeTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { [weak self] _ in
			guard let self else { return }
			self.router.close()
		})
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	public override func premiumDidChange() {}
}

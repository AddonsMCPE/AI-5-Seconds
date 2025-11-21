//
//  AlertController.swift
//  AI-Charades-UI
//
//  Created by User on 16.08.2023.
//

import UIKit

final class AlertController: ViewController<AlertView, AlertRouter> {
	// MARK: - Properties
	
	override var bgColor: UIColor! {
		return .colorBlue
	}
	
	// MARK: - Inits
	
	init(title: String?, message: String?) {
		super.init()
		
		_ = view
		mainView.title = title
		mainView.message = message
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func premiumDidChange() {}
	
	// MARK: - Methods
	
	func setActions(_ actions: [AlertAction]) {
		let cancelActions = actions.filter { $0.style == .cancel }
		let otherActions = actions.filter { $0.style != .cancel }
		if cancelActions.count > 1 {
			fatalError("no more than one cancel button can be added")
		}
		
		let createButton: (AlertAction) -> () = {
			let button = self.buttonFor(action: $0)
			self.mainView.buttonStackView.addArrangedSubview(button)
		}
		
		if otherActions.count > 1 {
			otherActions.forEach(createButton)
			cancelActions.forEach(createButton)
		} else {
			cancelActions.forEach(createButton)
			otherActions.forEach(createButton)
		}
		
		if (mainView.buttonStackView.arrangedSubviews.count) <= 2 {
			mainView.buttonStackView.axis = .horizontal
		} else {
			mainView.buttonStackView.axis = .vertical
		}
	}
}

// MARK: - Privates

private extension AlertController {
	func buttonFor(action: AlertAction) -> UIButton {
		let button = UIButton(type: .system)
		button.clipsToBounds = true
		button.layer.cornerRadius = 16
		button.titleLabel?.font = .extrabold20
		switch action.style {
		case .default:
			button.setBackgroundImage(UIImage(), for: .normal)
			button.backgroundColor = .colorGreen
			button.tintColor = .colorWhite
		case .destructive:
			button.setBackgroundImage(UIImage(), for: .normal)
			button.backgroundColor = .colorRed
			button.tintColor = .colorWhite
		case .cancel:
			button.setBackgroundImage(UIImage(), for: .normal)
			button.backgroundColor = .colorWhite.withAlphaComponent(0.2)
			button.tintColor = .colorWhite
		}
		button.setTitle(action.title, for: .normal)
		button.addAction(for: .touchUpInside) { [unowned self] _ in
			self.router.close()
			action.action?()
		}
		button.translatesAutoresizingMaskIntoConstraints = false
		button.heightAnchor.constraint(equalToConstant: 50).isActive = true
		return button
	}
	
	func viewFor(button: UIButton) -> UIView {
		let view = UIView()
		view.clipsToBounds = true
		view.addSubview(button)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		button.translatesAutoresizingMaskIntoConstraints = false
		button.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
		button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
		button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
		button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
		button.heightAnchor.constraint(equalToConstant: 44).isActive = true
		return view
	}
}

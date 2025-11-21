//
//  CustomTextView.swift
//  IA_Minecraft-UI
//
//  Created by Anna Radchenko on 06.08.2025.
//

import UIKit

public class CustomTextView: UITextView {
	public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		if #available(iOS 15.0, *) {
			if action == #selector(UIResponder.captureTextFromCamera(_:)) {
				return false
			}
		}
		return super.canPerformAction(action, withSender: sender)
	}
}

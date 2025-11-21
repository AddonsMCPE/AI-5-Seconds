//
//  NavigationModel.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 02.04.2023.
//

import UIKit

public class BarButtonItem: UIBarButtonItem {
	public typealias Action = NavigationModel.Action.Action
	
	private var actionClosure: Action?
	
	public convenience init(title: String, action: @escaping Action) {
		self.init(title: title, style: .plain, target: nil, action: nil)
		self.actionClosure = action
		self.action = #selector(didTap)
		self.target = self
	}
	
	public convenience init(image: UIImage, action: @escaping Action) {
		self.init(image: image, style: .plain, target: nil, action: nil)
		self.actionClosure = action
		self.action = #selector(didTap)
		self.target = self
	}
	
	@objc private func didTap() {
		actionClosure?()
	}
}

public struct NavigationModel {
	public struct Action {
		public typealias Action = () -> ()
		
		public enum Style {
			case normal
			case primary
			
			fileprivate var font: UIFont! {
				switch self {
				case .normal: return .medium16
				case .primary: return .medium16
				}
			}
		}
		
		let title: String?
		let icon: UIImage?
		let isEnabled: Bool
		let style: Style
		let action: Action
		
		var barButtonItem: BarButtonItem? {
			var item: BarButtonItem? = nil
			switch (title, icon) {
			case let (title?, _):
				item = BarButtonItem(title: title, action: action)
			case let (_, icon?):
				item = BarButtonItem(image: icon, action: action)
			default:
				break
			}
			
			item?.isEnabled = isEnabled
			item?.setTitleTextAttributes([.font : style.font!], for: [.normal])
			item?.setTitleTextAttributes([.font : style.font!], for: [.highlighted])
			item?.setTitleTextAttributes([.font : style.font!], for: [.disabled])
			item?.setTitleTextAttributes([.font : style.font!], for: [.focused])
			
			return item
		}
		
		public init(title: String, isEnabled: Bool = true, style: Style = .normal, action: @escaping Action) {
			self.init(title: title, icon: nil, isEnabled: isEnabled, style: style, action: action)
		}
		
		public init<L: Localizable>(title: L, isEnabled: Bool = true, style: Style = .normal, action: @escaping Action) {
			self.init(title: title.localized, icon: nil, isEnabled: isEnabled, style: style, action: action)
		}
		
		public init(icon: UIImage, isEnabled: Bool = true, style: Style = .normal, action: @escaping Action) {
			self.init(title: nil, icon: icon, isEnabled: isEnabled, style: style, action: action)
		}
		
		init(title: String?, icon: UIImage?, isEnabled: Bool, style: Style, action: @escaping Action) {
			self.title = title
			self.icon = icon
			self.isEnabled = isEnabled
			self.style = style
			self.action = action
		}
	}
	
	let title: String?
	let titleView: UIView?
	let leftActions: [Action]?
	let rightActions: [Action]?
	
	public init(title: String, leftActions: [Action]? = nil, rightActions: [Action]? = nil) {
		self.init(title: title, titleView: nil, leftActions: leftActions, rightActions: rightActions)
	}
	
	public init<L: Localizable>(title: L, leftActions: [Action]? = nil, rightActions: [Action]? = nil) {
		self.init(title: title.localized, titleView: nil, leftActions: leftActions, rightActions: rightActions)
	}
	
	public init(titleView: UIView, leftActions: [Action]? = nil, rightActions: [Action]? = nil) {
		self.init(title: nil, titleView: titleView, leftActions: leftActions, rightActions: rightActions)
	}
	
	init(title: String?, titleView: UIView?, leftActions: [Action]?, rightActions: [Action]?) {
		self.title = title
		self.titleView = titleView
		self.leftActions = leftActions
		self.rightActions = rightActions
	}
}

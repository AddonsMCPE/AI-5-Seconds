//
//	ClosureAction.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.08.2022.
//

import UIKit

private class ActionSleeve<Sender: UIControl>: NSObject {
	let events: UIControl.Event
	let action: (Sender) -> Void
	
	init(events: UIControl.Event, action: @escaping (Sender) -> Void) {
		self.events = events
		self.action = action
	}
	
	@objc func invoke(_ sender: UIControl) {
		action(sender as! Sender)
	}
}

public protocol ClosureAction: UIControl {
	associatedtype SenderType: UIControl
	typealias Action = (SenderType) -> ()
	
	func addAction(for events: Event, action: @escaping Action)
	func removeActions(for events: Event)
}

private var actionsKey = "ACTIONS_KEY"

extension ClosureAction {
	private var actions: [Any] {
		get {
			switch objc_getAssociatedObject(self, &actionsKey) as? [Any] {
			case .some(let value): return value
			case .none: return [ActionSleeve<UIControl>]()
			}
		}
		set {
			objc_setAssociatedObject(self, &actionsKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	public func addAction(for events: Event, action: @escaping Action) {
		let sleeve = ActionSleeve(events: events, action: action)
		addTarget(sleeve, action: #selector(ActionSleeve<SenderType>.invoke(_:)), for: events)
		actions.append(sleeve)
	}
	
	public func removeActions(for events: Event) {
		guard let actions = actions as? [ActionSleeve<UIControl>] else { return }
		actions.filter { $0.events.contains(events) }.forEach {
			removeTarget($0, action: #selector(ActionSleeve<SenderType>.invoke(_:)), for: events)
		}
	}
}

extension UIButton: ClosureAction {
	public typealias SenderType = UIButton
}

extension UISwitch: ClosureAction {
	public typealias SenderType = UISwitch
}

extension UISlider: ClosureAction {
	public typealias SenderType = UISlider
}

extension UITextField: ClosureAction {
	public typealias SenderType = UITextField
}

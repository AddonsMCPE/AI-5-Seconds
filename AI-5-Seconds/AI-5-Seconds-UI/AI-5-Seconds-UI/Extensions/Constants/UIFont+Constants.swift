//
//	UIFont+Constants.swift
//	Qibla-UI
//
//	Created by Anna Radchenko on 03.05.2022.
//

import UIKit

private extension UIFont {
	enum Style: String {
		case regular = "Regular"
		case medium = "Medium"
		case extrabold = "Extrabold"
		case black = "Black"
	}
	
	static func Nunito(of size: Float, style: Style) -> UIFont! {
		return UIFont(name: "Nunito-\(style.rawValue)", size: CGFloat(size)) ?? .systemFont(ofSize: CGFloat(size))
	}
}

public extension UIFont {
	static var regular12: UIFont! { return .Nunito(of: 12, style: .regular) }
	static var regular14: UIFont! { return .Nunito(of: 14, style: .regular) }
	static var regular16: UIFont! { return .Nunito(of: 16, style: .regular) }
	static var regular18: UIFont! { return .Nunito(of: 18, style: .regular) }
	
	static var medium12: UIFont! { return .Nunito(of: 12, style: .medium) }
	static var medium14: UIFont! { return .Nunito(of: 14, style: .medium) }
	static var medium16: UIFont! { return .Nunito(of: 16, style: .medium) }
	static var medium18: UIFont! { return .Nunito(of: 18, style: .medium) }
	static var medium20: UIFont! { return .Nunito(of: 20, style: .medium) }
	
	static var extrabold16: UIFont! { return .Nunito(of: 16, style: .extrabold) }
	static var extrabold18: UIFont! { return .Nunito(of: 18, style: .extrabold) }
	static var extrabold20: UIFont! { return .Nunito(of: 20, style: .extrabold) }
	static var extrabold24: UIFont! { return .Nunito(of: 24, style: .extrabold) }
	static var extrabold28: UIFont! { return .Nunito(of: 28, style: .extrabold) }
	static var extrabold36: UIFont! { return .Nunito(of: 36, style: .extrabold) }
	
	static var black16: UIFont! { return .Nunito(of: 16, style: .black) }
	static var black18: UIFont! { return .Nunito(of: 18, style: .black) }
	static var black20: UIFont! { return .Nunito(of: 20, style: .black) }
	static var black24: UIFont! { return .Nunito(of: 24, style: .black) }
	static var black28: UIFont! { return .Nunito(of: 28, style: .black) }
	static var black32: UIFont! { return .Nunito(of: 32, style: .black) }
	static var black42: UIFont! { return .Nunito(of: 42, style: .black) }
	static var black54: UIFont! { return .Nunito(of: 54, style: .black) }
	static var black80: UIFont! { return .Nunito(of: 80, style: .black) }
	static var black120: UIFont! { return .Nunito(of: 120, style: .black) }
	static var black160: UIFont! { return .Nunito(of: 160, style: .black) }
}

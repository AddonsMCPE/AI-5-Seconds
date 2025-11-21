//
//	HTMLLabel.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 20.10.2022.
//

//import UIKit
//
//open class HTMLLabel: UILabel {
//	var actualScaleFactor: CGFloat {
//		guard let attributedText = attributedText else { return font.pointSize }
//		let text = NSMutableAttributedString(attributedString: attributedText)
//		text.setAttributes([.font: font as Any], range: NSRange(location: 0, length: text.length))
//		let context = NSStringDrawingContext()
//		context.minimumScaleFactor = minimumScaleFactor
//		text.boundingRect(with: frame.size, options: .usesLineFragmentOrigin, context: context)
//		return context.actualScaleFactor
//	}
//	
//	open var htmlText: String? {
//		didSet {
//			guard let htmlText = htmlText else {
//				attributedText = nil
//				return
//			}
//			
//			//font-family: \(font.familyName);
//			//font-family: \(UIFont.extrabold18.familyName);
//			let html = """
//			<style>
//				text {
//					font-size: \(font.pointSize)px;
//					color: \(hexStringFromColor(color: textColor));
//				}
//				border {
//					font-size: \(font.pointSize+2)px;
//					color: \(hexStringFromColor(color: textColor));
//				}
//			</style>
//			<text>\(htmlText)</text>
//			"""
//			
//			let data = Data((html).utf8)
//			do {
//				let htmlAttributedString = try NSMutableAttributedString(data: data, options: [
//					.documentType : NSAttributedString.DocumentType.html,
//					.characterEncoding : String.Encoding.utf8.rawValue
//				], documentAttributes: nil)
//				
//				attributedText = htmlAttributedString.scaleBy(scale: 0.98)
//			} catch {
//				attributedText = nil
//				return
//			}
//		}
//	}
//	
//	private func hexStringFromColor(color: UIColor) -> String {
//		let components = color.cgColor.components
//		if components?.count == 2 && components?.first == 1 {
//			return "#FFFFFF"
//		}
//		let r: CGFloat = components?[0] ?? 0.0
//		let g: CGFloat = components?[1] ?? 0.0
//		let b: CGFloat = components?[2] ?? 0.0
//
//		let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
//		print(hexString)
//		return hexString
//	 }
//}
//
//extension NSAttributedString {
//	func scaleBy(scale: CGFloat) -> NSAttributedString {
//		let scaledAttributedString = NSMutableAttributedString(attributedString: self)
//		scaledAttributedString.enumerateAttribute(NSAttributedString.Key.font, in: NSRange(location: 0, length: scaledAttributedString.length), options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (value, range, _) in
//				if let oldFont = value as? UIFont {
//					let newFont = oldFont.withSize(oldFont.pointSize * scale)
//					scaledAttributedString.removeAttribute(NSAttributedString.Key.font, range: range)
//					scaledAttributedString.addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
//				}
//		}
//		return scaledAttributedString
//	}
//}

import UIKit

open class HTMLLabel: UILabel {
	
	open var lineSpacing: Double = 1.0
	
	open var htmlText: String? {
		didSet {
			guard let htmlText = htmlText else {
				attributedText = nil
				return
			}
			let copyFont = font
			let copyAlignment = textAlignment
			let copyAdjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
			let copyNumberOfLines = numberOfLines
			self.attributedText =
			prepereAttributedString(htmlString: htmlText, hexColor: hexString(from: self.textColor))
			adjustsFontSizeToFitWidth = copyAdjustsFontSizeToFitWidth
			font = copyFont
			textAlignment = copyAlignment
			lineBreakMode = .byTruncatingTail
			numberOfLines = copyNumberOfLines
			adjustsFontForContentSizeCategory = true
		}
	}

	private func prepereAttributedString(htmlString: String, hexColor: String) -> NSAttributedString? {
		let str = """
<style>
text {
line-height: \(lineSpacing);
color: \(hexColor);
}
border {
line-height: \(lineSpacing);
color: \(hexColor);
}
</style>
<text>\(htmlText!)</text>
"""
		//"<span style='color: \(hexColor)'>" + htmlString + "</span>"
		
		guard let data = str.data(using: .utf8) else { return nil }

		do {
			return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
		} catch {
			return nil
		}
	}
	
	private func hexString(from color: UIColor) -> String {
		let cgColorInRGB = color.cgColor.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
		let colorRef = cgColorInRGB.components
		let r = colorRef?[0] ?? 0
		let g = colorRef?[1] ?? 0
		let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
		let a = color.cgColor.alpha
		
		var color = String(
			format: "#%02lX%02lX%02lX",
			lroundf(Float(r * 255)),
			lroundf(Float(g * 255)),
			lroundf(Float(b * 255))
		)
		
		if a < 1 {
			color += String(format: "%02lX", lroundf(Float(a * 255)))
		}
		
		return color
	}
}

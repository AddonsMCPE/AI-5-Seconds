//
//  HTMLTextView.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 18.04.2023.
//

import UIKit

open class HTMLTextView: UITextView {

	open var htmlText: String? {
		didSet {
			guard let htmlText = htmlText else {
				attributedText = nil
				return
			}
			let copyFont = self.font
			let copyAlignment = NSTextAlignment.center
			self.attributedText =
			prepereAttributedString(htmlString: htmlText, hexColor: hexString(from: self.textColor ?? .colorWhite))
			font = copyFont
			textAlignment = copyAlignment
			adjustsFontForContentSizeCategory = true
		}
	}
	
	private func prepereAttributedString(htmlString: String, hexColor: String) -> NSAttributedString? {
		let str =
		"""
		<style>
			p {
				font-size: \((font ?? .systemFont(ofSize: 12)).pointSize)px;
				font-family: \((font ?? .systemFont(ofSize: 12)).familyName);
				color: \(hexColor);
			}
			a {
				color: #BA6AC7;
				text-decoration: none;
			}
		</style>
		<body>\(htmlString)</body>
		"""
		
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


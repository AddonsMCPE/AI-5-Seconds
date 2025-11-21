//
//  StrokedTextLabel.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 13.09.2025.
//

import UIKit

public final class StrokedTextLabel: UILabel {
	public var strokeColor: UIColor = .white.withAlphaComponent(0.2) {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public var strokeWidth: CGFloat = -7 {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public func setStrokedText(
		_ text: String,
		strokeColor: UIColor = .white.withAlphaComponent(0.2),
		strokeWidth: CGFloat = -7
	) {
		self.text = text
		self.strokeColor = strokeColor
		self.strokeWidth = strokeWidth
	}
	
	public override var text: String? { didSet { setNeedsDisplay() } }
	public override var attributedText: NSAttributedString? { didSet { setNeedsDisplay() } }
	public override var font: UIFont! { didSet { setNeedsDisplay() } }
	public override var textColor: UIColor! { didSet { setNeedsDisplay() } }
	public override var textAlignment: NSTextAlignment { didSet { setNeedsDisplay() } }
	public override var lineBreakMode: NSLineBreakMode { didSet { setNeedsDisplay() } }
	public override var numberOfLines: Int { didSet { setNeedsDisplay() } }
	
	public override func drawText(in rect: CGRect) {
		let drawRect = super.textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
		
		let style = NSMutableParagraphStyle()
		style.alignment = textAlignment
		style.lineBreakMode = lineBreakMode
		
		let base: NSAttributedString = {
			if let att = attributedText, att.length > 0 {
				return att
			} else {
				return NSAttributedString(
					string: text ?? "",
					attributes: [
						.font: font as Any,
						.paragraphStyle: style
					]
				)
			}
		}()
		
		let stroke = NSMutableAttributedString(attributedString: base)
		stroke.addAttributes([
			.strokeColor: strokeColor,
			.foregroundColor: UIColor.clear,
			.strokeWidth: strokeWidth
		], range: NSRange(location: 0, length: stroke.length))
		stroke.draw(in: drawRect)
		
		let fill = NSMutableAttributedString(attributedString: base)
		fill.addAttributes([
			.foregroundColor: textColor ?? .black,
			.strokeWidth: 0
		], range: NSRange(location: 0, length: fill.length))
		fill.draw(in: drawRect)
	}
	
	public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
	}
}

//
//  StrokedTitleButton.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 15.09.2025.
//

import UIKit

public class StrokedTitleButton: UIButton {
	
	private let strokedLabel = StrokedTextLabel()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	private func commonInit() {
		super.setTitle(nil, for: .normal)
		titleLabel?.isHidden = true
		
		strokedLabel.backgroundColor = .clear
		strokedLabel.textAlignment = .center
		strokedLabel.numberOfLines = 1
		addSubview(strokedLabel)
		
		isAccessibilityElement = true
		accessibilityTraits.insert(.button)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		strokedLabel.frame = titleLabel?.frame ?? .zero
	}
	
	public func setStrokedTitle(
		_ text: String?,
		fillColor: UIColor,
		font: UIFont? = nil,
		alignment: NSTextAlignment = .center
	) {
		setTitle(text, for: .normal)
		titleLabel?.font = font
		titleLabel?.text = text
		titleLabel?.textColor = .clear
		
		strokedLabel.setStyle(
			textColor: fillColor,
			font: font ?? .systemFont(ofSize: 17, weight: .semibold),
			numberOfLines: 1,
			textAlignment: .center,
			isScaleEnabled: false)
		strokedLabel.setStrokedText(text ?? "")
		
		accessibilityLabel = text
		setNeedsLayout()
		setNeedsDisplay()
	}
}

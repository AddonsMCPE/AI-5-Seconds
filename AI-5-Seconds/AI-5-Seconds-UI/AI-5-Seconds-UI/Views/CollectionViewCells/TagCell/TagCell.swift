//
//  TagCell.swift
//  IA_Minecraft-Settings
//
//  Created by Anna Radchenko on 11.03.2025.
//

import UIKit

public enum TagCellStatus {
	case selected, unselected
}

public final class TagCell: UICollectionViewCell, Reusable, NibRepresentable {
	// MARK: - Outlets
	
	@IBOutlet private var containerView: UIView! {
		didSet {
			containerView.backgroundColor = .clear
		}
	}
	
	@IBOutlet private var titleLabel: StrokedTextLabel! {
		didSet {
			titleLabel.setStyle(textColor: .colorWhite, font: .extrabold24, numberOfLines: 1, textAlignment: .center, isScaleEnabled: false)
			titleLabel.text = nil
		}
	}
	
	@IBOutlet private var selectedView: UIView! {
		didSet {
			selectedView.backgroundColor = .clear
		}
	}

	// MARK: - Properties
	
	public var titleText: String? {
		get { titleLabel.text }
		set { titleLabel.setStrokedText(newValue ?? "") }
	}
}

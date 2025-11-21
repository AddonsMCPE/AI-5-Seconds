//
//  TagFilledCell.swift
//  IA_Minecraft-UI
//
//  Created by Anna Radchenko on 06.08.2025.
//

import UIKit

public enum TagFilledCellStatus {
	case selected, unselected
}

public final class TagFilledCell: UICollectionViewCell, Reusable, NibRepresentable {
	// MARK: - Outlets
	
	@IBOutlet private var containerView: UIView! {
		didSet {
			containerView.backgroundColor = .clear
		}
	}
	
	@IBOutlet private var titleLabel: UILabel! {
		didSet {
			titleLabel.setStyle(textColor: .colorWhite, font: .medium14, numberOfLines: 1, textAlignment: .center, isScaleEnabled: false)
			titleLabel.text = nil
		}
	}

	// MARK: - Properties
	
	public var style: TagCellStatus = .unselected {
		didSet {
			containerView.backgroundColor = style == .selected ? .clear : .clear
		}
	}
	
	public var titleText: String? {
		get { titleLabel.text }
		set { titleLabel.text = newValue }
	}
}

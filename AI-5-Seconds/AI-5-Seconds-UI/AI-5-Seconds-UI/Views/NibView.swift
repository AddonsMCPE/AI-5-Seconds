//
//	NibView.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.08.2022.
//

import UIKit

open class NibView: UIView, NibRepresentable, NibLoadable {
	// MARK: - Properties
	
	public private(set) var contentView: UIView!
	
	open class var bundle: Bundle { Bundle(for: self) }
	open class var nibName: String {
		try! String(describing: self).substringMatches(regex: "[[:word:]]+").first!
	}
	
	// MARK: - Inits
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		contentView = loadNib(Self.nib)
		contentViewDidLoad()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		contentView = loadNib(Self.nib)
		contentViewDidLoad()
	}
	
	// MARK: - Lifecycle
	
	@objc open func contentViewDidLoad() {
		backgroundColor = .clear
	}
}

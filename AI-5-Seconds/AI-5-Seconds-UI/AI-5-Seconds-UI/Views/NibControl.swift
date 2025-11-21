//
//	NibControl.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.08.2022.
//

import UIKit

open class NibControl: UIControl, NibRepresentable, NibLoadable {
	// MARK: - Properties
	
	public private(set) var contentView: UIView!
	
	open class var bundle: Bundle { Bundle(for: self) }
	open class var nibName: String {
		try! String(describing: self).substringMatches(regex: "[[:word:]]+").first!
	}
	
	// MARK: - Inits
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		contentView = loadNib(type(of: self).nib)
		contentView.isUserInteractionEnabled = false
		contentViewDidLoad()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		contentView = loadNib(type(of: self).nib)
		contentView.isUserInteractionEnabled = false
		contentViewDidLoad()
	}
	
	// MARK: - Lifecycle
	
	@objc open func contentViewDidLoad() {
		backgroundColor = .clear
	}
}

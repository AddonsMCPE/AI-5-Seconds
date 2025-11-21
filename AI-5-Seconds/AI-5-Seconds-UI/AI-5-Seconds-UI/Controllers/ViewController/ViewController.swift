//
//	ViewController.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit

open class ViewController<View: UIView, Router: RouterProtocol>: BaseViewController, NibRepresentable {
	// MARK: - Properties
	
	public var router: Router!
	public private(set) var mainView: View! {
		get { view as? View }
		set {
			view = newValue
		}
	}
	
	// MARK: - Inits
	
	public init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View lifecycle
	
	open override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	open func loadMainNib() -> View {
		return Self.nib.instantiate(withOwner: self, options: nil).first as! View
	}
	
	open func loadMainView() -> View {
		return View.init()
	}
	
	public override func loadView() {
		if Self.canLoadNib {
			mainView = loadMainNib()
		} else {
			mainView = loadMainView()
		}
	}
}

//
//	BaseViewController.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 01.12.2022.
//

import UIKit
import Lottie

open class BaseViewController: UIViewController {
	// MARK: - Properties
	
	public var downloadingLable: UILabel?
	private var loadingTimer: Timer = Timer()
	private var loadingView: UIView! {
		didSet {
			loadingTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(addLoadingTapGesture), userInfo: nil, repeats: false)
		}
	}
	public var tapGesture: UITapGestureRecognizer?
	open var premium: Bool = false
	open var bgColor: UIColor! {
		return .clear
	}
	
	// MARK: - Inits
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	// MARK: - View lifecycle
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = bgColor
		premium = UserDefaults.premium
		NotificationCenter.default.addObserver(self, selector: #selector(handlePremiumChange), name: .premiumDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleThemeChange), name: .themeDidChange, object: nil)
		premiumDidChange()
	}
	
	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		premium = UserDefaults.premium
		DispatchQueue.main.async {
			self.navigationController?.navigationBar.sizeToFit()
		}
	}
	
	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
	}
	
	open override var prefersStatusBarHidden: Bool {
		true
	}
//	open override var shouldAutorotate: Bool {
//		return false
//	}
//
//	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//		return .portrait
//	}
//	open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//		return .portrait
//	}
	
	// MARK: - Public methods
	
	open func premiumDidChange() {
		fatalError("premiumDidChange has not been implemented")
	}
	
	open func themeDidChange() {
		// MARK: - Theme change here
	}
	
	open func addLoadingView(with animationName: String = "loading_green") {
		removeLoadingView()
		if let window = UIApplication.shared.windows.first {
			loadingView = UIView(frame: window.bounds)
			loadingView.backgroundColor = .black.withAlphaComponent(0.4)
			window.addSubview(loadingView)
			
			let animationView = AnimationView(name: animationName, bundle: Bundle.uiBundle)
			animationView.loopMode = .loop
			animationView.contentMode = .scaleAspectFill
			animationView.play()
			
			loadingView.addSubview(animationView)
			
			animationView.translatesAutoresizingMaskIntoConstraints = false
			animationView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: 0).isActive = true
			animationView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor, constant: 0).isActive = true
			animationView.widthAnchor.constraint(equalToConstant: 100).isActive = true
			animationView.heightAnchor.constraint(equalToConstant: 100).isActive = true
		}
	}
	
	open func removeLoadingView() {
		if let view = loadingView {
			loadingTimer.invalidate()
			view.removeFromSuperview()
		}
	}
	
	open func addDownloadingView() {
		removeDownloadingView()
		loadingView = UIView()
		loadingView.backgroundColor = .black.withAlphaComponent(0.8)
		loadingView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(loadingView)
		loadingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
		loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
		loadingView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
		loadingView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true

		downloadingLable = UILabel()
		downloadingLable?.setStyle(
			textColor: .colorWhite,
			font: .black20,
			numberOfLines: 1,
			textAlignment: .center,
			isScaleEnabled: false
		)
		downloadingLable?.text = "0 %"
		
		
		loadingView.addSubview(downloadingLable!)

		downloadingLable?.translatesAutoresizingMaskIntoConstraints = false
		downloadingLable?.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: 0).isActive = true
		downloadingLable?.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor, constant: 0).isActive = true
		//downloadingLable?.widthAnchor.constraint(equalToConstant: 80).isActive = true
		//downloadingLable?.heightAnchor.constraint(equalToConstant: 80).isActive = true
	}
	
	open func removeDownloadingView() {
		if let view = loadingView {
			loadingTimer.invalidate()
			view.removeFromSuperview()
		}
	}
	
	// MARK: - Actions
	
	open func hideKeyboardWhenTappedAround() {
		tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		guard let gesture = tapGesture else { return }
		gesture.cancelsTouchesInView = false//true
		view.addGestureRecognizer(gesture)
	}
	
	open func dissmissHideKeyboardWhenTappedAround() {
		guard let gesture = tapGesture else { return }
		gesture.cancelsTouchesInView = false
		view.removeGestureRecognizer(gesture)
		tapGesture = nil
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	@objc private func handlePremiumChange() {
		let newValue = UserDefaults.premium
		if (premium != newValue) {
			premium = newValue
			premiumDidChange()
		}
	}
	
	@objc private func handleThemeChange() {
		DispatchQueue.main.async {
			self.themeDidChange()
		}
	}
}

// MARK: - Internal

internal extension BaseViewController {
	// MARK: - Actions
	
	@objc private func addLoadingTapGesture() {
		if let view = loadingView {
			loadingTimer.invalidate()
			let tapsGesture = UITapGestureRecognizer(target: self, action: #selector(loadingGestureHandler(_:)))
			tapsGesture.numberOfTapsRequired = 3
			view.addGestureRecognizer(tapsGesture)
		}
	}
	
	@objc private func loadingGestureHandler(_ gesture: UITapGestureRecognizer) {
		guard (gesture.view) != nil else {
			return
		}
		loadingView?.gestureRecognizers?.removeAll()
		removeLoadingView()
	}
}

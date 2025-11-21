//
//	SliderPageControl.swift
//	AI-Charades-UI
//
//	Created by Anna Radchenko on 14.09.2022.
//

import UIKit

public final class SliderPageControl: NibControl {
	// MARK: - Private properties
	
	private var localNumberOfPages = NSInteger()
	private var localCurrentPage = NSInteger()
	private var localPointSize = CGSize()
	private var localPointSpace = CGFloat()
	private var localOtherColor = UIColor()
	private var localCurrentColor = UIColor()
	private var localOtherImage: UIImage?
	private var localCurrentImage: UIImage?
	private var localIsSquare = Bool()
	private var localCurrentWidthMultiple = CGFloat()
	private var localOtherBorderColor: UIColor?
	private var localOtherBorderWidth: CGFloat?
	private var localCurrentBorderColor: UIColor?
	private var localCurrentBorderWidth: CGFloat?
	private var clickIndex: ((_ result: NSInteger?) -> ())?

	// MARK: - Public properties
	
	public var numberOfPages: NSInteger {
		set {
			if localNumberOfPages == newValue {
				return
			}
			localNumberOfPages = newValue
			creatPointView()
		}
		get {
			return self.localNumberOfPages
		}
	}

	public var currentPage: NSInteger {
		set {
			if localCurrentPage == newValue {
				return
			}
			exchangeCurrentView(oldSelectedIndex: localCurrentPage, newSelectedIndex: newValue)
			localCurrentPage = newValue
		}
		get {
			return self.localCurrentPage
		}
	}

	public var pointSize: CGSize {
		set {
			if localPointSize != newValue {
				localPointSize = newValue
				creatPointView()
			}
		}
		get {
			return self.localPointSize
		}
	}

	public var pointSpace: CGFloat {
		set {
			if localPointSpace != newValue{
				localPointSpace = newValue
				creatPointView()
			}
		}
		get {
			return self.localPointSpace
		}
	}

	public var otherColor: UIColor {
		set {
			if localOtherColor != newValue {
				localOtherColor = newValue
				creatPointView()
			}
		}
		get {
			return self.localOtherColor
		}
	}

	public var currentColor: UIColor {
		set {
			if localCurrentColor != newValue {
				localCurrentColor = newValue
				creatPointView()
			}
		}
		get {
			return self.localCurrentColor
		}
	}

	public var otherImage: UIImage {
		set {
			if localOtherImage != newValue {
				localOtherImage = newValue
				creatPointView()
			}
		}
		get {
			return self.localOtherImage!
		}
	}

	public var currentImage: UIImage {
		set{
			if localCurrentImage != newValue {
				localCurrentImage = newValue
				creatPointView()
			}
		}
		get {
			return self.localCurrentImage!
		}
	}

	public var isSquare: Bool {
		set {
			if localIsSquare != newValue {
				localIsSquare = newValue
				creatPointView()
			}
		}
		get {
			return self.localIsSquare
		}
	}

	public var currentWidthMultiple: CGFloat {
		set {
			if localCurrentWidthMultiple != newValue {
				localCurrentWidthMultiple = newValue
				creatPointView()
			}
		}
		get {
			return self.localCurrentWidthMultiple
		}
	}

	public var otherBorderColor: UIColor {
		set {
			localOtherBorderColor = newValue
			creatPointView()
		}
		get {
			return self.localOtherBorderColor!
		}
	}

	public var otherBorderWidth: CGFloat {
		set {
			localOtherBorderWidth = newValue
			creatPointView()
		}
		get {
			return self.localOtherBorderWidth!
		}
	}

	public var currentBorderColor: UIColor {
		set {
			localCurrentBorderColor = newValue
			creatPointView()
		}
		get {
			return self.localCurrentBorderColor!
		}
	}

	public var currentBorderWidth: CGFloat {
		set {
			localCurrentBorderWidth = newValue
			creatPointView()
		}
		get {
			return self.localCurrentBorderWidth!
		}
	}
	
	// MARK: - Inits
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}

	// MARK: - Private methods
	
	private func initialize() {
		self.backgroundColor = UIColor.clear
		localNumberOfPages = 0
		localCurrentPage = 0
		localPointSize = CGSize.init(width: 8, height: 4)
		localPointSpace = 4
		localIsSquare = false
		localOtherColor = .green.withAlphaComponent(0.8)
		localCurrentColor = .clear
		localCurrentWidthMultiple = 1
		creatPointView()
	}
	
	private func creatPointView() {
		for view in self.subviews {
				view.removeFromSuperview()
		}

		if localNumberOfPages <= 0 {
				return
		}

		var startX: CGFloat = 0
		var startY:CGFloat = 0
		let mainWidth = CGFloat(localNumberOfPages) * (localPointSize.width + localPointSpace)

		if self.frame.size.width > mainWidth {
			startX = (self.frame.size.width - mainWidth) / 2
		}

		if self.frame.size.height > localPointSize.height {
			startY = (self.frame.size.height - localPointSize.height) / 2
		}
	
		for index in 0 ..< numberOfPages {
			if index == localCurrentPage {
				let currentPointView = UIView.init()
				let currentPointViewWidth = localPointSize.width * localCurrentWidthMultiple
				currentPointView.frame = CGRect.init(x: startX, y: startY, width: currentPointViewWidth, height: localPointSize.height)
				currentPointView.backgroundColor = localCurrentColor
				currentPointView.tag = index + 1000
				currentPointView.layer.cornerRadius = localIsSquare ? 0 : localPointSize.height / 2
				currentPointView.layer.masksToBounds = true
				currentPointView.layer.borderColor = localCurrentBorderColor != nil ? localCurrentBorderColor?.cgColor : localCurrentColor.cgColor
				currentPointView.layer.borderWidth = localCurrentBorderWidth != nil ? localCurrentBorderWidth! : 0
				currentPointView.isUserInteractionEnabled = true
				let gradient = CAGradientLayer()
				gradient.colors = [
					UIColor.green.cgColor,
					UIColor.green.cgColor
				]
				gradient.startPoint = CGPoint(x: 0, y: 0)
				gradient.endPoint = CGPoint(x: 1, y: 0)
				gradient.locations = [0, 1]
				gradient.frame = currentPointView.bounds
				currentPointView.layer.insertSublayer(gradient, at: 0)
				self.addSubview(currentPointView)
				let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(clickAction(tapGesture:)))
				currentPointView.addGestureRecognizer(tapGesture)
				startX = currentPointView.frame.maxX + localPointSpace

				if localCurrentImage != nil {
					currentPointView.backgroundColor = UIColor.clear
					let localCurrentImageView = UIImageView.init()
					localCurrentImageView.tag = index + 2000
					localCurrentImageView.frame = currentPointView.bounds
					localCurrentImageView.image = localCurrentImage
					currentPointView.addSubview(localCurrentImageView)
				}
			} else {
				let otherPointView = UIView.init()
				otherPointView.frame = CGRect.init(x: startX, y: startY, width: localPointSize.width, height: localPointSize.height)
				otherPointView.backgroundColor = localOtherColor
				otherPointView.tag = index + 1000
				otherPointView.layer.cornerRadius = localIsSquare ? 0 : localPointSize.height / 2;
				otherPointView.layer.borderColor = localOtherBorderColor != nil ? localOtherBorderColor?.cgColor : localOtherColor.cgColor
				otherPointView.layer.borderWidth = localOtherBorderWidth != nil ? localOtherBorderWidth! : 0
				otherPointView.layer.masksToBounds = true
				otherPointView.isUserInteractionEnabled = true
				self.addSubview(otherPointView)
				let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(clickAction(tapGesture:)))
				otherPointView.addGestureRecognizer(tapGesture)
				startX = otherPointView.frame.maxX + localPointSpace

				if localOtherImage != nil {
					otherPointView.backgroundColor = UIColor.clear
					let localOtherImageView = UIImageView.init()
					localOtherImageView.tag = index + 2000
					localOtherImageView.frame = otherPointView.bounds
					localOtherImageView.image = localOtherImage
					otherPointView.addSubview(localOtherImageView)
				}
			}
		}
	}

	private func exchangeCurrentView(oldSelectedIndex: NSInteger, newSelectedIndex: NSInteger) {
		let oldPointView = self.viewWithTag(1000 + oldSelectedIndex)
		let newPointView = self.viewWithTag(1000 + newSelectedIndex)

		oldPointView?.layer.borderColor = localOtherBorderColor != nil ? localOtherBorderColor?.cgColor : localOtherColor.cgColor
		oldPointView?.layer.borderWidth = localOtherBorderWidth != nil ? localOtherBorderWidth! : 0

		newPointView?.layer.borderColor = localCurrentBorderColor != nil ? localCurrentBorderColor?.cgColor : localCurrentColor.cgColor
		newPointView?.layer.borderWidth = localCurrentBorderWidth != nil ? localCurrentBorderWidth! : 0

		oldPointView?.backgroundColor = localOtherColor
		newPointView?.backgroundColor = localCurrentColor
		
		oldPointView?.layer.sublayers?.remove(at: 0)
		
		let gradient = CAGradientLayer()
		gradient.colors = [
			UIColor.green.cgColor,
			UIColor.green.cgColor
		]
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 1, y: 0)
		gradient.locations = [0, 1]
		gradient.frame = oldPointView?.bounds ?? .zero
		newPointView?.layer.insertSublayer(gradient, at: 0)
		
		if localCurrentWidthMultiple != 1 {
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
				var oldPointFrame = oldPointView?.frame
				if newSelectedIndex < oldSelectedIndex {
					oldPointFrame?.origin.x += self.localPointSize.width * (self.localCurrentWidthMultiple - 1)
				}
				oldPointFrame?.size.width = self.localPointSize.width
				oldPointView?.frame = oldPointFrame!

				var newPointFrame = newPointView?.frame
				if newSelectedIndex > oldSelectedIndex {
					newPointFrame?.origin.x -= self.localPointSize.width * (self.localCurrentWidthMultiple - 1)
				}
				newPointFrame?.size.width = self.localPointSize.width * self.localCurrentWidthMultiple
				newPointView?.frame = newPointFrame!
			}, completion: nil)
		}

		if localCurrentImage != nil {
			let view = oldPointView?.viewWithTag(oldSelectedIndex + 2000)
			if view != nil {
				let oldlocalCurrentImageView = view as! UIImageView
				oldlocalCurrentImageView.frame = CGRect.init(x: 0, y: 0, width: localPointSize.width, height: localPointSize.height)
				oldlocalCurrentImageView.image = localOtherImage
			}
		}

		if localOtherImage != nil {
			let view = newPointView?.viewWithTag(newSelectedIndex + 2000)
			if view != nil {
				let oldlocalOtherImageView = view as! UIImageView
				let width = localPointSize.width * localCurrentWidthMultiple
				oldlocalOtherImageView.frame = CGRect.init(x: 0, y: 0, width: width, height: localPointSize.height)
				oldlocalOtherImageView.image = localCurrentImage
			}
		}

		if newSelectedIndex - oldSelectedIndex > 1 {
			for index in oldSelectedIndex + 1 ..< newSelectedIndex {
				UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
					let view = self.viewWithTag(1000 + index)
					var frame = view?.frame
					frame?.origin.x -= self.localPointSize.width * (self.localCurrentWidthMultiple - 1)
					frame?.size.width = self.localPointSize.width
					view?.frame = frame!
				}, completion: nil)
			}
		}

		if newSelectedIndex - oldSelectedIndex < -1 {
			for index in newSelectedIndex + 1 ..< oldSelectedIndex {
				UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
					let view = self.viewWithTag(1000 + index)
					var frame = view?.frame
					frame?.origin.x += self.localPointSize.width * (self.localCurrentWidthMultiple - 1)
					frame?.size.width = self.localPointSize.width
					view?.frame = frame!
				}, completion: nil)
			}
		}
	}

	private func clickPoint(index: @escaping (_ result: NSInteger?) -> ()) {
		self.clickIndex = index
	}
	
	// MARK: - Actions
	
	@objc private func clickAction(tapGesture: UITapGestureRecognizer) {
		let index = (tapGesture.view?.tag)! - 1000
		self.clickIndex?(index)
	}
}

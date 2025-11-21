//
//  TagsLayout.swift
//  AI-Charades-Text
//
//  Created by Anna Radchenko on 14.02.2025.
//

//import UIKit
//
//public protocol TagsLayoutDelegate: AnyObject {
//	func collectionView(_ collectionView:UICollectionView, widthForTagAtIndexPath indexPath:IndexPath) -> CGFloat
//}
//
//public final class TagsLayout: UICollectionViewLayout {
//	// MARK: - Properties
//	
//	private weak var delegate: TagsLayoutDelegate?
//	private let numberOfRows: Int
//	private var columnsHeight: CGFloat
//	
//	private var cache = [UICollectionViewLayoutAttributes]()
//	private var contentWidth: CGFloat = 0
//	
//	private var height: CGFloat {
//		get {
//			return (collectionView?.frame.size.height)!
//		}
//	}
//	
//	// MARK: Inits
//	
//	public init(
//		delegate: TagsLayoutDelegate?,
//		numberOfRows: Int,
//		columnsHeight: CGFloat
//	) {
//		self.delegate = delegate
//		self.numberOfRows = numberOfRows
//		self.columnsHeight = columnsHeight
//		
//		super.init()
//	}
//	
//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//	
//	// MARK: - Lifecycle
//	
//	public override var collectionViewContentSize: CGSize {
//		return CGSize(width: contentWidth, height: height)
//	}
//
//	public override func prepare() {
//		if cache.isEmpty {
//			var yOffset = [CGFloat]()
//
//			for column in 0..<numberOfRows {
//				yOffset.append(CGFloat(column) * (columnsHeight + 8))
//			}
//
//			var xOffset = [CGFloat](repeating: 0, count: numberOfRows)
//			var column = 0
//
//			for item in 0..<collectionView!.numberOfItems(inSection: 0) {
//				let indexPath = IndexPath(item: item, section: 0)
//				guard let width = delegate?.collectionView(collectionView!, widthForTagAtIndexPath: indexPath) else {
//					return
//				}
//				let frame = CGRect(x: xOffset[column], y: yOffset[column], width: width, height: columnsHeight)
//				let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//				attributes.frame = frame
//				cache.append(attributes)
//				contentWidth = max(contentWidth, frame.maxX)
//				xOffset[column] = xOffset[column] + width + 8
//				column = column >= (numberOfRows - 1) ? 0 : column + 1
//			}
//		}
//	}
//
//	public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//		var layoutAttributes =  [UICollectionViewLayoutAttributes] ()
//		for attributes in cache {
//			if attributes.frame.intersects(rect) {
//				layoutAttributes.append(attributes)
//			}
//		}
//		return layoutAttributes
//	}
//}

import UIKit

public protocol TagsLayoutDelegate: AnyObject {
	func collectionView(_ collectionView: UICollectionView, widthForTagAtIndexPath indexPath: IndexPath) -> CGFloat
}

public final class TagsLayout: UICollectionViewLayout {
	
	public weak var delegate: TagsLayoutDelegate?
	
	public var numberOfRows: Int {
		didSet { guard numberOfRows > 0 else { numberOfRows = 1; return }; invalidateAndClear() }
	}
	
	public var rowHeight: CGFloat { didSet { invalidateAndClear() } }
	
	public var itemSpacing: CGFloat { didSet { invalidateAndClear() } }
	
	public var rowSpacing: CGFloat { didSet { invalidateAndClear() } }
	
	public var contentInsets: UIEdgeInsets { didSet { invalidateAndClear() } }
	
	// MARK: - Internals
	private var cache: [UICollectionViewLayoutAttributes] = []
	private var contentWidth: CGFloat = 0
	
	// MARK: - Init
	public init(
		delegate: TagsLayoutDelegate? = nil,
		numberOfRows: Int,
		rowHeight: CGFloat,
		itemSpacing: CGFloat = 8,
		rowSpacing: CGFloat = 8,
		contentInsets: UIEdgeInsets = .zero
	) {
		self.delegate = delegate
		self.numberOfRows = max(1, numberOfRows)
		self.rowHeight = rowHeight
		self.itemSpacing = itemSpacing
		self.rowSpacing = rowSpacing
		self.contentInsets = contentInsets
		super.init()
	}
	
	public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	// MARK: - Layout lifecycle
	public override var collectionViewContentSize: CGSize {
		guard let cv = collectionView else { return .zero }
		let rows = CGFloat(max(1, numberOfRows))
		let height =
		contentInsets.top
		+ rows * rowHeight
		+ max(0, rows - 1) * rowSpacing
		+ contentInsets.bottom
		
		let width = max(cv.bounds.width, contentWidth + contentInsets.right)
		return CGSize(width: width, height: height)
	}
	
	public override func prepare() {
		super.prepare()
		guard let cv = collectionView, cache.isEmpty else { return }
		
		var yOffsets: [CGFloat] = (0..<numberOfRows).map {
			contentInsets.top + CGFloat($0) * (rowHeight + rowSpacing)
		}
		
		var xOffsets: [CGFloat] = .init(repeating: contentInsets.left, count: numberOfRows)
		
		var currentRow = 0
		contentWidth = 0
		
		for section in 0..<cv.numberOfSections {
			for item in 0..<cv.numberOfItems(inSection: section) {
				let indexPath = IndexPath(item: item, section: section)
				guard let width = delegate?.collectionView(cv, widthForTagAtIndexPath: indexPath) else { continue }
				
				let frame = CGRect(
					x: xOffsets[currentRow],
					y: yOffsets[currentRow],
					width: width,
					height: rowHeight
				)
				
				let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
				attrs.frame = frame.integral
				cache.append(attrs)
				
				contentWidth = max(contentWidth, frame.maxX)
				
				xOffsets[currentRow] += width + itemSpacing
				currentRow = (currentRow >= numberOfRows - 1) ? 0 : currentRow + 1
			}
		}
	}
	
	public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		cache.filter { $0.frame.intersects(rect) }
	}
	
	public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		cache.first(where: { $0.indexPath == indexPath })
	}
	
	public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		guard let cv = collectionView else { return true }
		return cv.bounds.size != newBounds.size
	}
	
	public override func invalidateLayout() {
		super.invalidateLayout()
		cache.removeAll()
		contentWidth = 0
	}
	
	private func invalidateAndClear() {
		cache.removeAll()
		contentWidth = 0
		invalidateLayout()
	}
}

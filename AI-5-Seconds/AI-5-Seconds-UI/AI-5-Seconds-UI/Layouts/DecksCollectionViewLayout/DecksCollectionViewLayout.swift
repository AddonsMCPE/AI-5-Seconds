//
//  DecksCollectionViewLayout.swift
//  IA_Minecraft-UI
//
//  Created by Anna Radchenko on 07.08.2025.
//

//import UIKit
//
//public final class DecksCollectionViewLayout: UICollectionViewLayout {
//	
//	public var sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//	public var minimumLineSpacing: CGFloat = 10
//	public var minimumInteritemSpacing: CGFloat = 10
//	public var firstItemHeight: CGFloat = 92
//	
//	private let aspectRatio: CGFloat = 152.0 / 113.0
//	private var cache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
//	private var contentSize: CGSize = .zero
//	private var lastBoundsSize: CGSize = .zero
//	
//	public override func prepare() {
//		super.prepare()
//		guard let collectionView = collectionView else { return }
//		
//		if collectionView.bounds.size == lastBoundsSize, !cache.isEmpty {}
//		lastBoundsSize = collectionView.bounds.size
//		cache.removeAll()
//		
//		let contentWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
//		var yOffset: CGFloat = 0
//		
//		let sections = collectionView.numberOfSections
//		for section in 0..<sections {
//			yOffset += sectionInset.top
//			let items = collectionView.numberOfItems(inSection: section)
//			guard items > 0 else {
//				yOffset += sectionInset.bottom
//				continue
//			}
//			
//			let firstIndexPath = IndexPath(item: 0, section: section)
//			let firstAttr = UICollectionViewLayoutAttributes(forCellWith: firstIndexPath)
//			firstAttr.frame = CGRect(x: sectionInset.left, y: yOffset, width: contentWidth, height: firstItemHeight).integral
//			cache[firstIndexPath] = firstAttr
//			
//			yOffset = firstAttr.frame.maxY + minimumLineSpacing
//			
//			if items > 1 {
//				let columns = itemsPerRow(for: collectionView)
//				let totalInteritem = CGFloat(max(columns - 1, 0)) * minimumInteritemSpacing
//				let columnWidth = (contentWidth - totalInteritem) / CGFloat(columns)
//				let itemHeight = columnWidth * aspectRatio
//				
//				var xPositions: [CGFloat] = []
//				for column in 0..<columns {
//					let x = sectionInset.left + CGFloat(column) * (columnWidth + minimumInteritemSpacing)
//					xPositions.append(x)
//				}
//				
//				var columnHeights = Array(repeating: yOffset, count: columns)
//				
//				for item in 1..<items {
//					let indexPath = IndexPath(item: item, section: section)
//					let column = (item - 1) % columns
//					let x = xPositions[column]
//					let y = columnHeights[column]
//					
//					let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//					attributes.frame = CGRect(x: x, y: y, width: columnWidth, height: itemHeight).integral
//					cache[indexPath] = attributes
//					
//					columnHeights[column] = attributes.frame.maxY + minimumLineSpacing
//				}
//				
//				yOffset = (columnHeights.max() ?? yOffset) - minimumLineSpacing
//			}
//			
//			yOffset += sectionInset.bottom
//		}
//		
//		contentSize = CGSize(width: collectionView.bounds.width, height: yOffset)
//	}
//	
//	public override var collectionViewContentSize: CGSize { contentSize }
//	
//	public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//		cache.values.filter { $0.frame.intersects(rect) }
//	}
//	
//	public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//		cache[indexPath]
//	}
//	
//	public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//		newBounds.size != lastBoundsSize
//	}
//	
//	public override func invalidateLayout() {
//		super.invalidateLayout()
//		cache.removeAll()
//		contentSize = .zero
//	}
//	
//	public override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
//		super.prepare(forCollectionViewUpdates: updateItems)
//		cache.removeAll()
//	}
//	
//	private func itemsPerRow(for collectionView: UICollectionView) -> Int {
//		let idiom = collectionView.traitCollection.userInterfaceIdiom
//		let size = collectionView.bounds.size
//		let isLandscape = size.width > size.height
//		if idiom == .pad { return isLandscape ? 6 : 4 } else { return 3 }
//	}
//}

import UIKit

public final class DecksCollectionViewLayout: UICollectionViewLayout {
	
	// MARK: - Public
	public var sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
	public var minimumLineSpacing: CGFloat = 10
	public var minimumInteritemSpacing: CGFloat = 10
	public var firstItemHeight: CGFloat = 92
	public var isFirstItemOnFullScreen: Bool = true

	public var sectionHeaderHeight: CGFloat? = nil
	public var sectionHeaderKind: String = UICollectionView.elementKindSectionHeader
	public var headerBottomSpacing: CGFloat?

	// MARK: - Private
	private let aspectRatio: CGFloat = 152.0 / 113.0
	private var itemCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
	private var headerCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
	private var contentSize: CGSize = .zero
	private var lastBoundsSize: CGSize = .zero
	
	// MARK: - Layout
	public override func prepare() {
		super.prepare()
		guard let collectionView = collectionView else { return }
		
		if collectionView.bounds.size == lastBoundsSize, (!itemCache.isEmpty || !headerCache.isEmpty) { return }
		lastBoundsSize = collectionView.bounds.size
		itemCache.removeAll()
		headerCache.removeAll()
		
		let contentWidth = collectionView.bounds.width - sectionInset.left - sectionInset.right
		var yOffset: CGFloat = 0
		
		let sections = collectionView.numberOfSections
		for section in 0..<sections {
			yOffset += sectionInset.top
			
			if let headerH = sectionHeaderHeight, headerH > 0 {
				let headerIndexPath = IndexPath(item: 0, section: section)
				let headerAttr = UICollectionViewLayoutAttributes(
					forSupplementaryViewOfKind: sectionHeaderKind,
					with: headerIndexPath
				)
				headerAttr.frame = CGRect(
					x: sectionInset.left,
					y: yOffset,
					width: contentWidth,
					height: headerH
				).integral
				headerCache[headerIndexPath] = headerAttr
				yOffset = headerAttr.frame.maxY + (headerBottomSpacing ?? minimumLineSpacing)
			}
			
			let items = collectionView.numberOfItems(inSection: section)
			guard items > 0 else {
				yOffset += sectionInset.bottom
				continue
			}
			
			let startItemIndex: Int
			if isFirstItemOnFullScreen {
				let firstIndexPath = IndexPath(item: 0, section: section)
				let firstAttr = UICollectionViewLayoutAttributes(forCellWith: firstIndexPath)
				firstAttr.frame = CGRect(
					x: sectionInset.left,
					y: yOffset,
					width: contentWidth,
					height: firstItemHeight
				).integral
				itemCache[firstIndexPath] = firstAttr
				yOffset = firstAttr.frame.maxY + minimumLineSpacing
				startItemIndex = 1
			} else {
				startItemIndex = 0
			}
			
			if items > startItemIndex {
				let columns = itemsPerRow(for: collectionView)
				let totalInteritem = CGFloat(max(columns - 1, 0)) * minimumInteritemSpacing
				let columnWidth = (contentWidth - totalInteritem) / CGFloat(columns)
				let itemHeight = columnWidth * aspectRatio
				
				var xPositions: [CGFloat] = []
				for column in 0..<columns {
					let x = sectionInset.left + CGFloat(column) * (columnWidth + minimumInteritemSpacing)
					xPositions.append(x)
				}
				
				var columnHeights = Array(repeating: yOffset, count: columns)
				
				for item in startItemIndex..<items {
					let indexPath = IndexPath(item: item, section: section)
					let column = (item - startItemIndex) % columns
					let x = xPositions[column]
					let y = columnHeights[column]
					
					let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
					attributes.frame = CGRect(x: x, y: y, width: columnWidth, height: itemHeight).integral
					itemCache[indexPath] = attributes
					
					columnHeights[column] = attributes.frame.maxY + minimumLineSpacing
				}
				
				yOffset = (columnHeights.max() ?? yOffset) - minimumLineSpacing
			}
			
			yOffset += sectionInset.bottom
		}
		
		contentSize = CGSize(width: collectionView.bounds.width, height: yOffset)
	}
	
	public override var collectionViewContentSize: CGSize { contentSize }
	
	public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		let items = itemCache.values.filter { $0.frame.intersects(rect) }
		let headers = headerCache.values.filter { $0.frame.intersects(rect) }
		return items + headers
	}
	
	public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		itemCache[indexPath]
	}
	
	public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard elementKind == sectionHeaderKind else { return nil }
		return headerCache[indexPath]
	}
	
	public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		newBounds.size != lastBoundsSize
	}
	
	public override func invalidateLayout() {
		super.invalidateLayout()
		itemCache.removeAll()
		headerCache.removeAll()
		contentSize = .zero
	}
	
	public override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
		super.prepare(forCollectionViewUpdates: updateItems)
		itemCache.removeAll()
		headerCache.removeAll()
	}
	
	private func itemsPerRow(for collectionView: UICollectionView) -> Int {
		let idiom = collectionView.traitCollection.userInterfaceIdiom
		let size = collectionView.bounds.size
		let isLandscape = size.width > size.height
		if idiom == .pad { return isLandscape ? 6 : 4 } else { return 3 }
	}
}

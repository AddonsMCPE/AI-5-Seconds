//
//  PlayersCollectionViewLayout.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 22.09.2025.
//

import UIKit

public final class PlayersCollectionViewLayout: UICollectionViewLayout {
	
	public var sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
	public var minimumLineSpacing: CGFloat = 10
	public var minimumInteritemSpacing: CGFloat = 10
	public var firstItemHeight: CGFloat = 92
	
	private let heightByWidthRatio: CGFloat = 80.0 / 355.0//70.0 / 355.0
	
	private var cache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
	private var contentSize: CGSize = .zero
	private var lastBoundsSize: CGSize = .zero
	
	public override func prepare() {
		super.prepare()
		guard let collectionView = collectionView else { return }
		
		lastBoundsSize = collectionView.bounds.size
		cache.removeAll()
		
		let bounds = collectionView.bounds
		let contentWidth = max(0, bounds.width - sectionInset.left - sectionInset.right)
		
		var yOffset: CGFloat = 0
		let sections = collectionView.numberOfSections
		
		for section in 0..<sections {
			yOffset += sectionInset.top
			let items = collectionView.numberOfItems(inSection: section)
			
			guard items > 0 else {
				yOffset += sectionInset.bottom
				continue
			}
			
			let firstIndexPath = IndexPath(item: 0, section: section)
			let firstAttr = UICollectionViewLayoutAttributes(forCellWith: firstIndexPath)
			firstAttr.frame = CGRect(
				x: sectionInset.left,
				y: yOffset,
				width: contentWidth,
				height: firstItemHeight
			).integral
			cache[firstIndexPath] = firstAttr
			yOffset = firstAttr.frame.maxY + minimumLineSpacing
			
			if items > 1 {
				let columns = itemsPerRow(for: collectionView)
				let totalInteritem = CGFloat(max(columns - 1, 0)) * minimumInteritemSpacing
				let columnWidth = (contentWidth - totalInteritem) / CGFloat(columns)
				let itemHeight = columnWidth * heightByWidthRatio
				
				var xPositions: [CGFloat] = []
				for col in 0..<columns {
					let x = sectionInset.left + CGFloat(col) * (columnWidth + minimumInteritemSpacing)
					xPositions.append(x)
				}
				
				let startY = yOffset
				
				for item in 1..<items {
					let rel = item - 1
					let row = rel / columns
					let col = rel % columns
					
					let x = xPositions[col]
					let y = startY + CGFloat(row) * (itemHeight + minimumLineSpacing)
					
					let indexPath = IndexPath(item: item, section: section)
					let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
					attr.frame = CGRect(x: x, y: y, width: columnWidth, height: itemHeight).integral
					cache[indexPath] = attr
					
					if col == columns - 1 || item == items - 1 {
						yOffset = max(yOffset, attr.frame.maxY)
					}
				}
			}
			
			yOffset += sectionInset.bottom
		}
		
		contentSize = CGSize(width: bounds.width, height: yOffset)
	}
	
	public override var collectionViewContentSize: CGSize { contentSize }
	
	public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		cache.values.filter { $0.frame.intersects(rect) }
	}
	
	public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		cache[indexPath]
	}
	
	public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		newBounds.size != lastBoundsSize
	}
	
	public override func invalidateLayout() {
		super.invalidateLayout()
		cache.removeAll()
		contentSize = .zero
	}
	
	public override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
		super.prepare(forCollectionViewUpdates: updateItems)
		cache.removeAll()
	}
	
	// MARK: - Helpers
	
	private func itemsPerRow(for collectionView: UICollectionView) -> Int {
		let idiom = collectionView.traitCollection.userInterfaceIdiom
		let size = collectionView.bounds.size
		let isLandscape = size.width > size.height
		
		if idiom == .pad {
			return isLandscape ? 3 : 2
		} else {
			return 1
		}
	}
}

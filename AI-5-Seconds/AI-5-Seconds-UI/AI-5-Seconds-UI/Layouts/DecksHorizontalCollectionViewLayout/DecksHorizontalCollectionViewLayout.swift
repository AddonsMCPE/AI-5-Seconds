//
//  DecksHorizontalCollectionViewLayout.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 24.09.2025.
//

import UIKit

public final class DecksHorizontalCollectionViewLayout: UICollectionViewLayout {
	
	public var sectionInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
	public var minimumLineSpacing: CGFloat = 10
	public var minimumInteritemSpacing: CGFloat = 10
	
	private let aspectRatio: CGFloat = 158.0 / 210.0
	private var cache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
	private var contentSize: CGSize = .zero
	private var lastBoundsSize: CGSize = .zero
	
	public override func prepare() {
		super.prepare()
		guard let collectionView = collectionView else { return }
		
		if collectionView.bounds.size == lastBoundsSize, !cache.isEmpty { return }
		lastBoundsSize = collectionView.bounds.size
		cache.removeAll()
		
		let availableHeight = max(0, collectionView.bounds.height - sectionInset.top - sectionInset.bottom)
		guard availableHeight > 0 else {
			contentSize = .zero
			return
		}
		
		let itemWidth = floor(availableHeight * aspectRatio)
		
		var xOffset: CGFloat = 0
		var contentHeight: CGFloat = collectionView.bounds.height
		
		let sections = collectionView.numberOfSections
		for section in 0..<sections {
			xOffset += sectionInset.left
			let items = collectionView.numberOfItems(inSection: section)
			
			if items > 0 {
				var lastFrameMaxX = xOffset
				for item in 0..<items {
					let indexPath = IndexPath(item: item, section: section)
					let frame = CGRect(
						x: xOffset,
						y: sectionInset.top,
						width: itemWidth,
						height: availableHeight
					).integral
					
					let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
					attributes.frame = frame
					cache[indexPath] = attributes
					
					lastFrameMaxX = frame.maxX
					xOffset = frame.maxX + minimumInteritemSpacing
				}
				
				xOffset = lastFrameMaxX
			}
			
			xOffset += sectionInset.right
		}
		
		contentSize = CGSize(width: max(xOffset, collectionView.bounds.width), height: contentHeight)
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
}

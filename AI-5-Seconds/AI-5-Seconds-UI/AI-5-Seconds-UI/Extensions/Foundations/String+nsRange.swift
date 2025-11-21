//
//  String+nsRange.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 21.09.2023.
//

import Foundation

public extension String {
	var nsRange : NSRange {
		return NSRange(self.startIndex..., in: self)
	}
}

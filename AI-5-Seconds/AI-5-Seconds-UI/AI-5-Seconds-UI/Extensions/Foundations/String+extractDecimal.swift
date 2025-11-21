//
//  String+extractDecimal.swift
//  AI-Charades-UI
//
//  Created by Anna Radchenko on 07.03.2025.
//

import Foundation

public extension String {
	func extractCurrencyAndDecimal() -> (currency: String, amount: Decimal)? {
		// Регулярное выражение для поиска валюты и числа с десятичной точкой
		let regex = try! NSRegularExpression(pattern: "([\\D]+)?(\\d+(\\.\\d+)?)", options: [])
		
		// Ищем первое совпадение
		if let match = regex.firstMatch(in: self, options: [], range: NSRange(self.startIndex..., in: self)) {
			// Извлекаем валюту (если она есть) и число
			let currencyRange = match.range(at: 1)
			let amountRange = match.range(at: 2)
			
			// Получаем валюту (если она есть) или пустую строку
			let currency = currencyRange.location != NSNotFound ? (self as NSString).substring(with: currencyRange).trimmingCharacters(in: .whitespaces) : ""
			
			// Извлекаем число
			let amountString = (self as NSString).substring(with: amountRange)
			
			// Преобразуем строку с числом в Decimal
			if let amount = Decimal(string: amountString) {
				return (currency, amount)
			}
		}
		
		return nil
	}
}

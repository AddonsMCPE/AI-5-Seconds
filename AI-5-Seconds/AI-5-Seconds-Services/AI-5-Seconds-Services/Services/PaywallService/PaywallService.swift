//
//  PaywallService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 17.11.2023.
//

public class PaywallService {
	static let shared = PaywallService()
	
	private var paywallCounter = 0
	
	public func openPaywall() -> Bool {
		paywallCounter += 1
		if paywallCounter % 15 == 0 {
			return true
		}
		return false
	}
}

//
//	NetworkService.swift
//	AI-Charades-Services
//
//	Created by Anna Radchenko on 14.11.2022.
//

import Foundation
import SystemConfiguration

public enum NetworkServiceResult {
	case connectionIsAvailable(_ _bool: Bool)
}

public final class NetworkService: NSObject {
	public typealias Observer = (NetworkServiceResult) -> ()
	
	// MARK: - Public properties
	
	public var observer: Observer? {
		didSet {
			if observer == nil {
				timer.invalidate()
			}
		}
	}

	// MARK: - Private properties
	
	private var timer = Timer()
	
	// MARK: - Inits
	
	public override init() {
		super.init()
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkConnection), userInfo: nil, repeats: false)
	}
	
	// MARK: - Private methods
	
	@objc private func checkConnection() {
		observer?(.connectionIsAvailable(isConnectedToNetwork()))
		timer.invalidate()
		timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkConnection), userInfo: nil, repeats: false)
	}
	
	private func isConnectedToNetwork() -> Bool {
		var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)

		let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
				SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
			}
		}

		var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
		if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
			return false
		}
		
		let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
		let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		let res = (isReachable && !needsConnection)

		return res
	}
}

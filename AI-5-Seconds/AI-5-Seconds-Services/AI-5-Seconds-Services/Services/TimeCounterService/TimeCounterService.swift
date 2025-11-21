//
//  TimeCounterService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 24.09.2025.
//

import Foundation

public final class TimeCounterService {
	public struct Config {
		public let minSeconds: Int
		public let maxSeconds: Int
		public let step: Int
		public let defaultSeconds: Int
		public let defaultsKey: String
		public init(
			minSeconds: Int = 30,
			maxSeconds: Int = 300,
			step: Int = 10,
			defaultSeconds: Int = 60,
			defaultsKey: String = "time.counter.seconds"
		) {
			self.minSeconds = minSeconds
			self.maxSeconds = maxSeconds
			self.step = step
			self.defaultSeconds = defaultSeconds
			self.defaultsKey = defaultsKey
		}
	}
	
	public var onChange: ((Int, String) -> Void)?
	
	private var _seconds: Int?
	public var seconds: Int {
		get {
			if let v = _seconds { return v }
			let hasStored = defaults.object(forKey: cfg.defaultsKey) != nil
			let stored = defaults.integer(forKey: cfg.defaultsKey)
			let initial = Self.clamp(hasStored ? stored : cfg.defaultSeconds, cfg.minSeconds, cfg.maxSeconds)
			_seconds = initial
			if !hasStored { persist(initial) }
			return initial
		}
		set {
			let clamped = Self.clamp(newValue, cfg.minSeconds, cfg.maxSeconds)
			guard clamped != _seconds else { return }
			_seconds = clamped
			persist(clamped)
			onChange?(clamped, formatted)
		}
	}
	
	public var formatted: String {
		String(format: "%02d:%02d", seconds / 60, seconds % 60)
	}
	
	public var isAtMin: Bool { seconds <= cfg.minSeconds }
	public var isAtMax: Bool { seconds >= cfg.maxSeconds }
	
	private let defaults: UserDefaults
	private let cfg: Config
	
	public init(defaults: UserDefaults = .standard, config: Config = .init()) {
		self.defaults = defaults
		self.cfg = config
	}
	
	@discardableResult
	public func increment() -> Int { set(seconds + cfg.step) }
	
	@discardableResult
	public func decrement() -> Int { set(seconds - cfg.step) }
	
	@discardableResult
	public func set(_ v: Int) -> Int {
		seconds = v
		return seconds
	}
	
	@discardableResult
	public func resetToDefault() -> Int {
		seconds = cfg.defaultSeconds
		return seconds
	}
	
	public func reloadFromStorage() {
		_seconds = nil
	}
	
	private func persist(_ value: Int) {
		defaults.set(value, forKey: cfg.defaultsKey)
	}
	
	private static func clamp(_ v: Int, _ lo: Int, _ hi: Int) -> Int {
		max(lo, min(hi, v))
	}
}

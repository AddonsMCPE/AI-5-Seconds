//
//  DeckWordsService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 29.09.2025.
//

import UIKit
import AI_Charades_UI
import Foundation

// MARK: - Colors

public enum WordColor: String, Codable, CaseIterable {
	case colorGreen
	case colorRed
	case colorYellow
	case colorCyan
	case colorPurple

	public var uiColor: UIColor {
		switch self {
		case .colorGreen:  return .colorGreen
		case .colorRed:    return .colorRed
		case .colorYellow: return .colorYellow
		case .colorCyan:   return .colorCyan
		case .colorPurple: return .colorPurple
		}
	}
}

// MARK: - Deck

public enum DeckKind: String, Codable, CaseIterable, Hashable {
	case custom1 = "Custom 1"
	case custom2 = "Custom 2"
	case custom3 = "Custom 3"
	case aiDeck  = "AI Deck"
}

// MARK: - Model

public struct WordEntry: Codable, Equatable, Hashable {
	public let id: UUID
	public var text: String?
	public var dateAdded: Date
	public var color: WordColor

	public init(
		id: UUID = UUID(),
		text: String? = nil,
		dateAdded: Date = Date(),
		color: WordColor
	) {
		self.id = id
		self.text = text
		self.dateAdded = dateAdded
		self.color = color
	}
	
	public init(from decoder: Decoder) throws {
		let c = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try c.decode(UUID.self, forKey: .id)
		self.text = try c.decodeIfPresent(String.self, forKey: .text)
		self.dateAdded = try c.decodeIfPresent(Date.self, forKey: .dateAdded) ?? Date()
		self.color = try c.decodeIfPresent(WordColor.self, forKey: .color) ?? .colorGreen
	}
}

// MARK: - Service

public final class DeckWordsService {
	public let deck: DeckKind
	public let maxWordsPerDeck = 300

	private var storage: [WordEntry] = []
	private let defaults: UserDefaults
	private let keyPrefix = "deck.words.store.v1."

	// Персистимо індекс кольору окремо для кожної колоди
	private var nextColorIndex: Int {
		get { defaults.integer(forKey: keyColorIndex()) }
		set { defaults.set(newValue, forKey: keyColorIndex()) }
	}

	public init(deck: DeckKind, defaults: UserDefaults = .standard) {
		self.deck = deck
		self.defaults = defaults
	}

	private func key() -> String { keyPrefix + deck.rawValue }
	private func keyColorIndex() -> String { "deck.words.color.index.\(deck.rawValue)" }

	// Циклічний вибір кольору
	private func nextColorAndAdvance() -> WordColor {
		let colors = WordColor.allCases
		let color = colors[nextColorIndex % colors.count]
		nextColorIndex = (nextColorIndex + 1) % colors.count
		return color
	}

	public func reload(from entries: [WordEntry]) {
		storage = Array(entries.prefix(maxWordsPerDeck))
	}

	public func snapshot() -> [WordEntry] { storage }

	public func words() -> [WordEntry] {
		storage.sorted { $0.dateAdded < $1.dateAdded }
	}

	public func count() -> Int { storage.count }

	public func isFull() -> Bool { storage.count >= maxWordsPerDeck }

	public func nextWord(after current: WordEntry) -> WordEntry? {
		let arr = words()
		guard !arr.isEmpty else { return nil }
		guard let idx = arr.firstIndex(of: current) else { return arr.first }
		return arr[(idx + 1) % arr.count]
	}

	@discardableResult
	public func add(text: String? = nil) -> WordEntry? {
		guard storage.count < maxWordsPerDeck else { return nil }
		let entry = WordEntry(text: text, color: nextColorAndAdvance())
		storage.append(entry)
		return entry
	}

	@discardableResult
	public func add(texts: [String?]) -> [WordEntry] {
		var added: [WordEntry] = []
		for t in texts {
			guard let e = add(text: t) else { break }
			added.append(e)
		}
		return added
	}

	@discardableResult
	public func updateText(at index: Int, to newText: String?) -> WordEntry? {
		guard storage.indices.contains(index) else { return nil }
		storage[index].text = newText
		return storage[index]
	}

	@discardableResult
	public func updateText(id: UUID, to newText: String?) -> WordEntry? {
		guard let idx = storage.firstIndex(where: { $0.id == id }) else { return nil }
		storage[idx].text = newText
		return storage[idx]
	}

	@discardableResult
	public func delete(id: UUID) -> Bool {
		guard let idx = storage.firstIndex(where: { $0.id == id }) else { return false }
		storage.remove(at: idx)
		return true
	}

	public func clear() {
		storage = []
		nextColorIndex = 0
	}

	public func replace(with entries: [WordEntry]) {
		storage = Array(entries.prefix(maxWordsPerDeck))
		recalculateNextColorIndex()
	}

	@discardableResult
	public func saveToDefaults() -> Bool {
		do {
			switch deck {
			case .custom1: UserDefaults.wordsCountInCustom1 = storage.count
			case .custom2: UserDefaults.wordsCountInCustom2 = storage.count
			case .custom3: UserDefaults.wordsCountInCustom3 = storage.count
			case .aiDeck:  UserDefaults.wordsCountInAiDeck  = storage.count
			}
			let data = try JSONEncoder().encode(storage)
			defaults.set(data, forKey: key())
			return true
		} catch {
			return false
		}
	}

	@discardableResult
	public func loadFromDefaults() -> Bool {
		guard let data = defaults.data(forKey: key()) else {
			storage = []
			nextColorIndex = 0
			return false
		}
		do {
			let decoded = try JSONDecoder().decode([WordEntry].self, from: data)
			storage = Array(decoded.prefix(maxWordsPerDeck))
			
			if needsColorMigration(storage) {
				assignColorsCyclically()
			}
			
			recalculateNextColorIndex()
			return true
		} catch {
			storage = []
			nextColorIndex = 0
			return false
		}
	}

	@discardableResult
	public func saveCleaningEmptyAndNilTextsToDefaults() -> Int {
		let cleaned = storage.filter { entry in
			if let t = entry.text {
				return t.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
			}
			return false
		}
		storage = Array(cleaned.prefix(maxWordsPerDeck))
		guard let data = try? JSONEncoder().encode(storage) else { return 0 }
		defaults.set(data, forKey: key())
		recalculateNextColorIndex()
		return storage.count
	}
}

// MARK: - Private helpers

private extension DeckWordsService {
	func needsColorMigration(_ arr: [WordEntry]) -> Bool {
		guard let first = arr.first else { return false }
		return arr.allSatisfy { $0.color == first.color }
	}

	func assignColorsCyclically() {
		let colors = WordColor.allCases
		var idx = 0
		let ordered = words()
		var map: [UUID: WordColor] = [:]
		for item in ordered {
			map[item.id] = colors[idx % colors.count]
			idx += 1
		}
		for i in storage.indices {
			if let c = map[storage[i].id] {
				storage[i].color = c
			}
		}
	}

	func recalculateNextColorIndex() {
		nextColorIndex = storage.count % WordColor.allCases.count
	}
}

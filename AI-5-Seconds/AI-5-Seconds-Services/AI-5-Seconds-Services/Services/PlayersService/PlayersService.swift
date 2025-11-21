//
//  PlayersService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 22.09.2025.
//

import UIKit
import AI_Charades_UI

public enum PlayerColor: String, Codable, CaseIterable {
	case colorGreen
	case colorRed
	case colorYellow
	case colorCyan
	case colorPurple
	
	public var uiColor: UIColor {
		switch self {
		case .colorGreen: return .colorGreen
		case .colorRed: return .colorRed
		case .colorYellow: return .colorYellow
		case .colorCyan: return .colorCyan
		case .colorPurple: return .colorPurple
		}
	}
	
	public var icon: UIImage {
		switch self {
		case .colorGreen: return .iconStartGreen
		case .colorRed: return .iconStartRed
		case .colorYellow: return .iconStartYellow
		case .colorCyan: return .iconStartCyan
		case .colorPurple: return .iconStartPurple
		}
	}
}

public struct Player: Codable, Equatable, Hashable {
	public let id: UUID
	public var name: String?
	public var color: PlayerColor
	public var score: Int
	public var dateAdded: Date

	public init(id: UUID = UUID(), name: String?, color: PlayerColor, score: Int = 0, dateAdded: Date = Date()) {
		self.id = id
		self.name = name
		self.color = color
		self.score = score
		self.dateAdded = dateAdded
	}

	private enum CodingKeys: String, CodingKey { case id, name, color, score, dateAdded }

	public init(from decoder: Decoder) throws {
		let c = try decoder.container(keyedBy: CodingKeys.self)
		id = try c.decode(UUID.self, forKey: .id)
		name = try c.decodeIfPresent(String.self, forKey: .name)
		color = try c.decode(PlayerColor.self, forKey: .color)
		score = try c.decode(Int.self, forKey: .score)
		dateAdded = try c.decodeIfPresent(Date.self, forKey: .dateAdded) ?? .distantPast
	}
}

public final class PlayersService {
	public static let shared = PlayersService()
	
	public var players: [Player] { _players.sorted { $0.dateAdded < $1.dateAdded } }
	public let maxPlayers = 10
	
	private let defaults = UserDefaults.standard
	private let playersKey = "players.store.v1.players"
	private let nextColorKey = "players.store.v1.nextColorIndex"
	private var _players: [Player] = []
	private var nextColorIndex: Int = 0
	
	private init() {
		loadFromDefaults()
		if _players.isEmpty {
			_players = [Player(name: LS.Game.Label.guest.localized, color: .colorGreen, score: 0, dateAdded: Date())]
			nextColorIndex = 1 % PlayerColor.allCases.count
			persist()
		}
	}
	
	public func reload() {
		loadFromDefaults()
	}
	
	@discardableResult
	public func add(name: String? = nil, score: Int = 0) -> Player? {
		guard _players.count < maxPlayers else { return nil }
		let color = nextColorAndAdvance()
		let trimmed = (name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
		let finalName = trimmed.isEmpty ? nil : trimmed
		let player = Player(name: finalName, color: color, score: score, dateAdded: Date())
		_players.append(player)
		persist()
		return player
	}
	
	@discardableResult
	public func delete(id: UUID) -> Bool {
		if let idx = _players.firstIndex(where: { $0.id == id }) {
			_players.remove(at: idx)
			persist()
			return true
		}
		return false
	}
	
	@discardableResult
	public func updateName(at index: Int, to newName: String?) -> Player? {
		guard _players.indices.contains(index) else { return nil }
		let trimmed = (newName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
		_players[index].name = trimmed.isEmpty ? nil : trimmed
		persist()
		return _players[index]
	}
	
	@discardableResult
	public func updateScore(at index: Int, to newScore: Int) -> Player? {
		guard _players.indices.contains(index) else { return nil }
		_players[index].score = newScore
		persist()
		return _players[index]
	}
	
	@discardableResult
	public func updateScore(for player: Player, to newScore: Int) -> Player? {
		guard let idx = _players.firstIndex(where: { $0.id == player.id }) else { return nil }
		_players[idx].score = newScore
		persist()
		return _players[idx]
	}
	
	@discardableResult
	public func nextPlayer(after current: Player) -> Player? {
		let arr = players
		guard !arr.isEmpty else { return nil }
		guard let idx = arr.firstIndex(of: current) else { return arr.first }
		let nextIdx = (idx + 1) % arr.count
		return arr[nextIdx]
	}
	
	public func resetAllScores() {
		guard !_players.isEmpty else { return }
		for i in _players.indices { _players[i].score = 0 }
		persist()
	}
	
	public func deleteAllPlayers() {
		_players.removeAll()
		nextColorIndex = 0
		persist()
	}
	
	// MARK: - Private methods
	
	private func loadFromDefaults() {
		if let data = defaults.data(forKey: playersKey),
			 let decoded = try? JSONDecoder().decode([Player].self, from: data) {
			var arr = Array(decoded.prefix(maxPlayers))
			if arr.contains(where: { $0.dateAdded == .distantPast }) {
				let base = Date(timeIntervalSince1970: 0)
				for i in arr.indices {
					if arr[i].dateAdded == .distantPast {
						arr[i].dateAdded = base.addingTimeInterval(TimeInterval(i))
					}
				}
			}
			_players = arr
		} else {
			_players = []
		}
		if defaults.object(forKey: nextColorKey) != nil {
			nextColorIndex = defaults.integer(forKey: nextColorKey)
		} else {
			nextColorIndex = _players.count % PlayerColor.allCases.count
		}
	}
	
	private func persist() {
		if let data = try? JSONEncoder().encode(_players) {
			defaults.set(data, forKey: playersKey)
		}
		defaults.set(nextColorIndex, forKey: nextColorKey)
	}
	
	private func nextColorAndAdvance() -> PlayerColor {
		let colors = PlayerColor.allCases
		let color = colors[nextColorIndex % colors.count]
		nextColorIndex = (nextColorIndex + 1) % colors.count
		return color
	}
}

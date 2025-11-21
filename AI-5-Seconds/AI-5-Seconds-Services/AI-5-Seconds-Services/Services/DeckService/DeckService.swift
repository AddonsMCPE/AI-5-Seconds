//
//  DeckService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 18.09.2025.
//

import UIKit
import AI_Charades_UI

public enum DeckTheme: String, CaseIterable, Codable, Hashable {
	case music = "Music"
	case religionAndMythology = "Religion & Mythology"
	case kidsEmoji = "Kids (Emoji)"
	case sportsAndGames = "Sports & Games"
	case videoGamesAndGeek = "Video Games & Geek"
	case natureAndAnimals = "Nature & Animals"
	case spaceAndScience = "Space & Science"
	case foodAndDrinks = "Food & Drinks"
	case transport = "Transport"
	case fashionAndStyle = "Fashion & Style"
	case travelAndPlaces = "Travel & Places"
	case holidaysAndEvents = "Holidays & Events"
	case peopleAndCharacters = "People & Characters"
	case comicsAndSuperheroes = "Comics & Superheroes"
	case mediaAndEntertainment = "Media & Entertainment"
	case education = "Education"
	case technologyAndTools = "Technology & Tools"
	case fantasy = "Fantasy"
	case toys = "Toys"
	case customAndAI = "Custom & AI"
	case movies = "Movies"
	case series = "Series"
	case general = "General"
	case pantomime = "Pantomime"
	case anime = "Anime"
	case all = "All"
	case free = "Free"
	case premium = "Premium"

	public var localized: String {
		switch self {
		case .music: return LS.Game.Label.themeMusic.localized
		case .religionAndMythology: return LS.Game.Label.themeReligion.localized
		case .kidsEmoji: return LS.Game.Label.themeKids.localized
		case .sportsAndGames: return LS.Game.Label.themeSports.localized
		case .videoGamesAndGeek: return LS.Game.Label.themeVideo.localized
		case .natureAndAnimals: return LS.Game.Label.themeNature.localized
		case .spaceAndScience: return LS.Game.Label.themeSpace.localized
		case .foodAndDrinks: return LS.Game.Label.themeFood.localized
		case .transport: return LS.Game.Label.themeTransport.localized
		case .fashionAndStyle: return LS.Game.Label.themeFashion.localized
		case .travelAndPlaces: return LS.Game.Label.themeTravel.localized
		case .holidaysAndEvents: return LS.Game.Label.themeHolidays.localized
		case .peopleAndCharacters: return LS.Game.Label.themePeople.localized
		case .comicsAndSuperheroes: return LS.Game.Label.themeComics.localized
		case .mediaAndEntertainment: return LS.Game.Label.themeMedia.localized
		case .education: return LS.Game.Label.themeEducation.localized
		case .technologyAndTools: return LS.Game.Label.themeTechnology.localized
		case .fantasy: return LS.Game.Label.themeFantasy.localized
		case .toys: return LS.Game.Label.themeToys.localized
		case .customAndAI: return LS.Game.Label.themeCustom.localized
		case .movies: return LS.Game.Label.themeMovies.localized
		case .series: return LS.Game.Label.themeSeries.localized
		case .general: return LS.Game.Label.themeGeneral.localized
		case .pantomime: return LS.Game.Label.themePantomime.localized
		case .anime: return LS.Game.Label.themeAnime.localized
		case .all: return LS.Game.Label.themeAll.localized
		case .free: return LS.Game.Label.themeFree.localized
		case .premium: return LS.Game.Label.themePremium.localized
		}
	}
}

public struct DeckIndexFile: Codable {
	public let version: Int
	public let decks: [DeckIndexEntry]
}

public struct DeckIndexEntry: Codable, Hashable {
	public let id: UUID
	public let titleKey: String
	public let descriptionKey: String
	public let imageName: String
	public let fileName: String
	public let theme: DeckTheme
	public let isPremium: Bool
	public let isSeason: Bool
	public let isNew: Bool

	enum CodingKeys: String, CodingKey {
		case id, titleKey, descriptionKey, imageName, fileName, theme, isPremium, isSeason, isNew
	}

	public init(from decoder: Decoder) throws {
		let c = try decoder.container(keyedBy: CodingKeys.self)
		id = try c.decode(UUID.self, forKey: .id)
		titleKey = try c.decode(String.self, forKey: .titleKey)
		descriptionKey = try c.decode(String.self, forKey: .descriptionKey)
		imageName = try c.decode(String.self, forKey: .imageName)
		fileName = try c.decode(String.self, forKey: .fileName)
		if let raw = try c.decodeIfPresent(String.self, forKey: .theme),
			 let t = DeckTheme(rawValue: raw) {
			theme = t
		} else {
			theme = .general
		}
		isPremium = try c.decodeIfPresent(Bool.self, forKey: .isPremium) ?? true
		isSeason = try c.decodeIfPresent(Bool.self, forKey: .isSeason) ?? false
		isNew = try c.decodeIfPresent(Bool.self, forKey: .isNew) ?? false
	}

	public init(
		id: UUID,
		titleKey: String,
		descriptionKey: String,
		imageName: String,
		fileName: String,
		theme: DeckTheme,
		isPremium: Bool,
		isSeason: Bool,
		isNew: Bool
	) {
		self.id = id
		self.titleKey = titleKey
		self.descriptionKey = descriptionKey
		self.imageName = imageName
		self.fileName = fileName
		self.theme = theme
		self.isPremium = isPremium
		self.isSeason = isSeason
		self.isNew = isNew
	}
}

public struct DeckFile: Codable {
	public let id: UUID
	public let descriptionKey: String
	public let words: DeckWords
}

public struct DeckWords: Codable {
	public let easy: [WordRef]
	public let normal: [WordRef]
	public let hard: [WordRef]
}

public struct WordRef: Codable, Hashable {
	public let key: String
}

public struct DeckSummary: Identifiable, Hashable {
	public let id: UUID
	public let title: String
	public let subtitle: String
	public let image: UIImage?
	public let fileName: String
	public let titleKey: String
	public let descriptionKey: String
	public let theme: DeckTheme
	public let isPremium: Bool
	public let isSeason: Bool
	public let isNew: Bool

	public init(
		id: UUID,
		title: String,
		subtitle: String,
		image: UIImage?,
		fileName: String,
		titleKey: String,
		descriptionKey: String,
		theme: DeckTheme,
		isPremium: Bool,
		isSeason: Bool,
		isNew: Bool
	) {
		self.id = id
		self.title = title
		self.subtitle = subtitle
		self.image = image
		self.fileName = fileName
		self.titleKey = titleKey
		self.descriptionKey = descriptionKey
		self.theme = theme
		self.isPremium = isPremium
		self.isSeason = isSeason
		self.isNew = isNew
	}
}

public struct DeckDetail: Identifiable, Hashable {
	public let id: UUID
	public let title: String
	public let description: String
	public let easy: [String]
	public let normal: [String]
	public let hard: [String]

	public init(
		id: UUID,
		title: String,
		description: String,
		easy: [String],
		normal: [String],
		hard: [String]
	) {
		self.id = id
		self.title = title
		self.description = description
		self.easy = easy
		self.normal = normal
		self.hard = hard
	}
}

public enum DeckServiceError: LocalizedError {
	case indexFileNotFound(String)
	case deckFileNotFound(String)
	case decodingFailed(underlying: Error)
	case deckNotInIndex(UUID)
	case imageMissing(String)

	public var errorDescription: String? {
		switch self {
		case .indexFileNotFound(let name): return "DeckIndex not found: \(name)"
		case .deckFileNotFound(let name): return "Deck file not found: \(name)"
		case .decodingFailed(let err): return "JSON decoding failed: \(err.localizedDescription)"
		case .deckNotInIndex(let id): return "Deck with id \(id) is not in DeckIndex"
		case .imageMissing(let name): return "Image not found in asset catalog: \(name)"
		}
	}
}

private enum DeckLanguageResolver {
	static let supportedLanguageCodes: Set<String> = [
		"en","en-AU","en-IN","en-GB",
		"cs",
		"fr","fr-CA",
		"de",
		"it",
		"pl",
		"pt-BR","pt-PT",
		"ru",
		"es","es-419","es-US",
		"th",
		"tr",
		"uk"
	]

	private static func normalize(_ code: String) -> String {
		let canon = Locale.canonicalLanguageIdentifier(from: code)
		return canon.replacingOccurrences(of: "_", with: "-")
	}

	static func bestMatch(requested: String?, devicePreferred: [String], fallback: String) -> String {
		let fallback = normalize(fallback)
		let candidates: [String] = [requested.map(normalize)].compactMap { $0 } + devicePreferred.map(normalize)
		for cand in candidates {
			if supportedLanguageCodes.contains(cand) { return cand }
			if let base = cand.split(separator: "-").first.map(String.init) {
				if supportedLanguageCodes.contains(base) { return base }
				if let regional = supportedLanguageCodes.first(where: { $0.hasPrefix(base + "-") }) {
					return regional
				}
			}
		}
		return supportedLanguageCodes.contains(fallback) ? fallback : "en"
	}
}

private final class StringsProvider {
	private let bundle: Bundle
	private var cache: [String: [String: [String: String]]] = [:]

	init(bundle: Bundle) { self.bundle = bundle }

	private func dictionaries(for localizationCode: String, table: String) -> [[String: String]] {
		let locs = bundle.localizations

		func dictAt(_ code: String) -> [String: String]? {
			guard let path = bundle.path(forResource: table, ofType: "strings", inDirectory: nil, forLocalization: code),
						let dict = NSDictionary(contentsOfFile: path) as? [String: String] else { return nil }
			return dict
		}

		var result: [[String: String]] = []

		if let exact = dictAt(localizationCode) { result.append(exact) }

		if let baseLang = localizationCode.split(separator: "-").first.map(String.init) {
			if let regional = locs.first(where: { $0.hasPrefix(baseLang + "-") }),
				 let d = dictAt(regional) {
				result.append(d)
			}
			if let d = dictAt(baseLang) { result.append(d) }
		}

		if let d = dictAt("Base") { result.append(d) }

		return result
	}

	func string(key: String, tables: [String?], localizationCode: String) -> String? {
		let loc = localizationCode
		for tableOpt in tables {
			let table = (tableOpt ?? "Localizable")
			let cacheKey = loc + "||" + table
			if cache[cacheKey] == nil {
				let merged = dictionaries(for: loc, table: table).reduce(into: [String: String]()) { acc, d in
					for (k, v) in d where acc[k] == nil { acc[k] = v }
				}
				cache[cacheKey] = [table: merged]
			}
			if let value = cache[cacheKey]?[table]?[key] { return value }
		}
		return nil
	}
}

public final class DeckService {
	public static let defaultResourceBundleIdentifier = "ai.charades.deck.difficulty.AI-Charades-UI"

	public struct Configuration {
		public var indexFileName: String = "DeckIndex.json"
		public var globalStringsTable: String? = nil
		public var usePerDeckStringsTable: Bool = true
		public var bundle: Bundle
		public var decoder: JSONDecoder = JSONDecoder()
		public var enforceImageExistence: Bool = false
		public var preferredLanguageCode: String? = nil
		public var fallbackLanguageCode: String = "en"

		public init(bundle: Bundle? = nil) {
			if let provided = bundle {
				self.bundle = provided
			} else if let b = Bundle(identifier: DeckService.defaultResourceBundleIdentifier) {
				self.bundle = b
			} else {
				self.bundle = .main
			}
		}
	}

	private var cfg: Configuration
	private let stringsProvider: StringsProvider
	private var indexCache: [UUID: DeckIndexEntry] = [:]
	private var summariesCache: [DeckSummary]? = nil
	private var detailsCache: [UUID: DeckDetail] = [:]

	public init(configuration: Configuration = Configuration()) {
		self.cfg = configuration
		self.stringsProvider = StringsProvider(bundle: configuration.bundle)
	}

	public convenience init(
		bundleIdentifier: String? = DeckService.defaultResourceBundleIdentifier,
		globalStringsTable: String? = nil,
		usePerDeckStringsTable: Bool = true
	) {
		var config = Configuration(bundle: bundleIdentifier.flatMap { Bundle(identifier: $0) } ?? .main)
		config.globalStringsTable = globalStringsTable
		config.usePerDeckStringsTable = usePerDeckStringsTable
		self.init(configuration: config)
	}

	public func setPreferredLanguageCode(_ code: String?) {
		cfg.preferredLanguageCode = code
		summariesCache = nil
		detailsCache.removeAll()
	}

	public func effectiveLanguageCode() -> String {
		DeckLanguageResolver.bestMatch(
			requested: cfg.preferredLanguageCode,
			devicePreferred: Locale.preferredLanguages,
			fallback: cfg.fallbackLanguageCode
		)
	}

//	@discardableResult
//	public func loadDeckSummaries() throws -> [DeckSummary] {
//		let index = try loadIndexFile()
//		indexCache = Dictionary(uniqueKeysWithValues: index.decks.map { ($0.id, $0) })
//		let code = effectiveLanguageCode()
//		let summariesUnsorted: [DeckSummary] = index.decks.map { entry in
//			let perDeckTable = tableNameForDeck(fileName: entry.fileName)
//			let title = localize(entry.titleKey, preferredTables: [cfg.globalStringsTable, perDeckTable, "Decks", nil], code: code)
//			let subtitle = localize(entry.descriptionKey, preferredTables: [cfg.globalStringsTable, perDeckTable, "Decks", nil], code: code)
//			let image = UIImage(named: entry.imageName, in: cfg.bundle, compatibleWith: nil)
//			return DeckSummary(
//				id: entry.id,
//				title: title,
//				subtitle: subtitle,
//				image: image,
//				fileName: entry.fileName,
//				titleKey: entry.titleKey,
//				descriptionKey: entry.descriptionKey,
//				theme: entry.theme,
//				isPremium: entry.isPremium,
//				isSeason: entry.isSeason,
//				isNew: entry.isNew
//			)
//		}
//		let summaries = summariesUnsorted.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
//		summariesCache = summaries
//		return summaries
//	}
	
	@discardableResult
	public func loadDeckSummaries() throws -> [DeckSummary] {
		let index = try loadIndexFile()
		indexCache = Dictionary(uniqueKeysWithValues: index.decks.map { ($0.id, $0) })
		let code = effectiveLanguageCode()

		let summariesUnsorted: [DeckSummary] = index.decks.map { entry in
			let perDeckTable = tableNameForDeck(fileName: entry.fileName)
			let title = localize(entry.titleKey, preferredTables: [cfg.globalStringsTable, perDeckTable, "Decks", nil], code: code)
			let subtitle = localize(entry.descriptionKey, preferredTables: [cfg.globalStringsTable, perDeckTable, "Decks", nil], code: code)
			let image = UIImage(named: entry.imageName, in: cfg.bundle, compatibleWith: nil)
			return DeckSummary(
				id: entry.id,
				title: title,
				subtitle: subtitle,
				image: image,
				fileName: entry.fileName,
				titleKey: entry.titleKey,
				descriptionKey: entry.descriptionKey,
				theme: entry.theme,
				isPremium: entry.isPremium,
				isSeason: entry.isSeason,
				isNew: entry.isNew
			)
		}
		let summaries = summariesUnsorted.sorted { a, b in
			func rank(_ s: DeckSummary) -> Int {
				if s.isSeason { return 0 }
				if s.isNew { return 1 }
				return 2
			}
			let ra = rank(a), rb = rank(b)
			if ra != rb { return ra < rb }
			return a.title.localizedCaseInsensitiveCompare(b.title) == .orderedAscending
		}

		summariesCache = summaries
		return summaries
	}

	public func loadDeck(id: UUID) throws -> DeckDetail {
		if let cached = detailsCache[id] { return cached }
		let entry = try entryForDeck(id: id)
		let deck = try loadDeckFile(fileName: entry.fileName)
		let code = effectiveLanguageCode()
		let title = localize(entry.titleKey, preferredTables: [cfg.globalStringsTable, tableNameForDeck(fileName: entry.fileName), nil], code: code)
		let description = localize(deck.descriptionKey, preferredTables: [cfg.globalStringsTable, tableNameForDeck(fileName: entry.fileName), nil], code: code)
		let perDeckTable = cfg.usePerDeckStringsTable ? tableNameForDeck(fileName: entry.fileName) : nil
		let wordTables: [String?] = [perDeckTable, cfg.globalStringsTable, nil]
		let easy = deck.words.easy.map { localize($0.key, preferredTables: wordTables, code: code) }
		let normal = deck.words.normal.map { localize($0.key, preferredTables: wordTables, code: code) }
		let hard = deck.words.hard.map { localize($0.key, preferredTables: wordTables, code: code) }
		let result = DeckDetail(id: entry.id, title: title, description: description, easy: easy, normal: normal, hard: hard)
		detailsCache[id] = result
		return result
	}

	public func loadDeck(fileName: String) throws -> DeckDetail {
		if indexCache.isEmpty { _ = try? loadDeckSummaries() }
		let code = effectiveLanguageCode()
		if let entry = indexCache.values.first(where: { $0.fileName == fileName }) {
			return try loadDeck(id: entry.id)
		}
		let deck = try loadDeckFile(fileName: fileName)
		let perDeckTable = cfg.usePerDeckStringsTable ? tableNameForDeck(fileName: fileName) : nil
		let tables: [String?] = [perDeckTable, cfg.globalStringsTable, nil]
		let titleKeyGuess = "deck.\(fileNameWithoutExt(fileName)).title"
		let title = localize(titleKeyGuess, preferredTables: tables, code: code)
		let description = localize(deck.descriptionKey, preferredTables: tables, code: code)
		let easy = deck.words.easy.map { localize($0.key, preferredTables: tables, code: code) }
		let normal = deck.words.normal.map { localize($0.key, preferredTables: tables, code: code) }
		let hard = deck.words.hard.map { localize($0.key, preferredTables: tables, code: code) }
		return DeckDetail(id: deck.id, title: title, description: description, easy: easy, normal: normal, hard: hard)
	}

//	public func loadDeckSummariesFreeFirst() throws -> [DeckSummary] {
//		let list = try loadDeckSummaries()
//		return list.sorted { a, b in
//			if a.isPremium == b.isPremium {
//				return a.title.localizedCaseInsensitiveCompare(b.title) == .orderedAscending
//			}
//			return a.isPremium == false && b.isPremium == true
//		}
//	}
	
	public func loadDeckSummariesFreeFirst() throws -> [DeckSummary] {
		let list = try loadDeckSummaries()
		return list.sorted { a, b in
			func rank(_ s: DeckSummary) -> Int {
				if s.isSeason { return 0 }
				if s.isPremium == false { return 1 }
				return 2
			}
			let ra = rank(a), rb = rank(b)
			if ra != rb { return ra < rb }
			return a.title.localizedCaseInsensitiveCompare(b.title) == .orderedAscending
		}
	}
	
	public func themesList() throws -> [DeckTheme] {
		Array(Set(try summaries().map(\.theme))).sorted { $0.rawValue < $1.rawValue }
	}

	public func summaries(forTheme theme: DeckTheme) throws -> [DeckSummary] {
		try summaries().filter { $0.theme == theme }
	}

	public func aiSummaries() throws -> [DeckSummary] {
		try summaries().filter { $0.fileName == "aiDeck.json" }
	}

	public func freeSummaries() throws -> [DeckSummary] {
		try summaries().filter { !$0.isPremium }
	}

	public func premiumSummaries() throws -> [DeckSummary] {
		try summaries().filter { $0.isPremium }
	}

	public func groupedByTheme() throws -> [DeckTheme: [DeckSummary]] {
		let list = try summaries()
		return Dictionary(grouping: list, by: { $0.theme })
	}

	public func isPremium(id: UUID) throws -> Bool {
		let list = try summaries()
		return list.first(where: { $0.id == id })?.isPremium ?? true
	}

	public func theme(for id: UUID) throws -> DeckTheme {
		let list = try summaries()
		return list.first(where: { $0.id == id })?.theme ?? .general
	}

	private func summaries() throws -> [DeckSummary] {
		if let cache = summariesCache { return cache }
		return try loadDeckSummaries()
	}

	private func entryForDeck(id: UUID) throws -> DeckIndexEntry {
		if let cached = indexCache[id] { return cached }
		_ = try loadDeckSummaries()
		if let cached = indexCache[id] { return cached }
		throw DeckServiceError.deckNotInIndex(id)
	}

	private func loadIndexFile() throws -> DeckIndexFile {
		let (resource, ext) = splitFileName(cfg.indexFileName, defaultExt: "json")
		guard let url = cfg.bundle.url(forResource: resource, withExtension: ext) else {
			throw DeckServiceError.indexFileNotFound(cfg.indexFileName)
		}
		do {
			let data = try Data(contentsOf: url)
			return try cfg.decoder.decode(DeckIndexFile.self, from: data)
		} catch {
			throw DeckServiceError.decodingFailed(underlying: error)
		}
	}

	private func loadDeckFile(fileName: String) throws -> DeckFile {
		let (resource, ext) = splitFileName(fileName, defaultExt: "json")
		guard let url = cfg.bundle.url(forResource: resource, withExtension: ext) else {
			throw DeckServiceError.deckFileNotFound(fileName)
		}
		do {
			let data = try Data(contentsOf: url)
			return try cfg.decoder.decode(DeckFile.self, from: data)
		} catch {
			throw DeckServiceError.decodingFailed(underlying: error)
		}
	}

	private func splitFileName(_ fileName: String, defaultExt: String) -> (String, String) {
		let parts = fileName.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true)
		if parts.count == 2 { return (String(parts[0]), String(parts[1])) }
		return (fileName, defaultExt)
	}

	private func fileNameWithoutExt(_ fileName: String) -> String {
		fileName.components(separatedBy: ".").first ?? fileName
	}

	private func localize(_ key: String, preferredTables tables: [String?], code: String) -> String {
		if let v = stringsProvider.string(key: key, tables: tables, localizationCode: code) { return v }
		if let pretty = prettifyFromKey(key) { return pretty }
		return key
	}

	private func prettifyFromKey(_ key: String) -> String? {
		let last = key.split(separator: ".").last.map(String.init) ?? key
		var s = last.replacingOccurrences(of: "_", with: " ")
		var out: [Character] = []
		var prevLower = false
		for ch in s {
			if ch.isUppercase && prevLower { out.append(" ") }
			out.append(ch)
			prevLower = ch.isLowercase
		}
		s = String(out)
		return s.capitalized.replacingOccurrences(of: "  ", with: " ")
	}

	private func tableNameForDeck(fileName: String) -> String? {
		let name = fileNameWithoutExt(fileName)
		return name.isEmpty ? nil : name
	}
}

#if DEBUG
extension DeckService {
	public func debugPrintLocalizationInfo() {
		let code = effectiveLanguageCode()
		print("RESOURCE BUNDLE:", cfg.bundle.bundleIdentifier ?? "main")
		print("EFFECTIVE LANGUAGE:", code)
		print("AVAILABLE:", cfg.bundle.localizations)
	}
}
#endif

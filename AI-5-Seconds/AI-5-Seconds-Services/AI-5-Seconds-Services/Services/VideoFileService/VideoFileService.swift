//
//  VideoFileService.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 05.10.2025.
//

import Foundation
import AVFoundation
import UIKit

public struct VideoItem: Identifiable, Equatable {
	public let id = UUID()
	public let url: URL
	public let createdAt: Date
}

public enum VideoFilePath {
	public static func newOutputURL() -> URL {
		let fm = FileManager.default
		let base = (try? fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true))
		?? fm.temporaryDirectory
		let fmt = DateFormatter(); fmt.dateFormat = "yyyy-MM-dd_HH-mm-ss"
		return base.appendingPathComponent("FrontCam_\(fmt.string(from: Date())).mov")
	}
}

public actor VideoFileService {
	public static let shared = VideoFileService()
	
	private let maxVideos = 10
	private let fm = FileManager.default
	private let thumbsCache = NSCache<NSURL, UIImage>()
	
	private let directory: URL
	
	public init(directory: URL? = nil) {
		if let directory {
			self.directory = directory
		} else {
			let base = (try? fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true))
			?? fm.temporaryDirectory
			self.directory = base
		}
		thumbsCache.countLimit = 100
	}
	
	public func makeNewOutputURL() -> URL {
		let fmt = DateFormatter()
		fmt.dateFormat = "yyyy-MM-dd_HH-mm-ss"
		let name = "FrontCam_\(fmt.string(from: Date())).mov"
		return directory.appendingPathComponent(name)
	}
	
	public func registerRecording(at url: URL) async {
		await ensureCapacityForNewFile()
		
		let isAlreadyInDir = (url.deletingLastPathComponent() == directory)
		let destination = isAlreadyInDir ? url : directory.appendingPathComponent(url.lastPathComponent)
		
		guard destination != url else {
			return
		}
		
		do {
			if fm.fileExists(atPath: destination.path) {
				try fm.removeItem(at: destination)
			}
			try fm.moveItem(at: url, to: destination)
		} catch {
			do {
				if fm.fileExists(atPath: destination.path) {
					try fm.removeItem(at: destination)
				}
				try fm.copyItem(at: url, to: destination)
				try? fm.removeItem(at: url)
			} catch {
				
			}
		}
	}
	
	private func ensureCapacityForNewFile() {
		let items = listVideos()
		guard items.count >= maxVideos else { return }
		if let oldest = items.last {
			try? fm.removeItem(at: oldest.url)
			thumbsCache.removeObject(forKey: oldest.url as NSURL)
		}
	}
	
	public func lastVideo() -> VideoItem? { listVideos().first }
	public func lastVideoURL() -> URL? { lastVideo()?.url }
	
	public func listVideos() -> [VideoItem] {
		guard let urls = try? fm.contentsOfDirectory(at: directory, includingPropertiesForKeys: [
			.creationDateKey, .contentModificationDateKey
		], options: [.skipsHiddenFiles]) else { return [] }
		
		let videoURLs = urls.filter { url in
			let ext = url.pathExtension.lowercased()
			return ext == "mov" || ext == "mp4"
		}
		
		let items: [VideoItem] = videoURLs.compactMap { url in
			let date = (try? url.resourceValues(forKeys: [.creationDateKey]).creationDate)
			?? ((try? fm.attributesOfItem(atPath: url.path)[.creationDate]) as? Date)
			?? Date.distantPast
			return VideoItem(url: url, createdAt: date)
		}
		
		return items.sorted { $0.createdAt > $1.createdAt }
	}
	
	public func thumbnail(for url: URL, at seconds: Double = 0.5) -> UIImage? {
		if let cached = thumbsCache.object(forKey: url as NSURL) { return cached }
		let asset = AVURLAsset(url: url)
		let gen = AVAssetImageGenerator(asset: asset)
		gen.appliesPreferredTrackTransform = true
		gen.maximumSize = CGSize(width: 640, height: 640)
		
		let time = CMTime(seconds: seconds, preferredTimescale: 600)
		do {
			let cg = try gen.copyCGImage(at: time, actualTime: nil)
			let img = UIImage(cgImage: cg)
			thumbsCache.setObject(img, forKey: url as NSURL)
			return img
		} catch {
			do {
				let cg = try gen.copyCGImage(at: .zero, actualTime: nil)
				let img = UIImage(cgImage: cg)
				thumbsCache.setObject(img, forKey: url as NSURL)
				return img
			} catch {
				return nil
			}
		}
	}
	
	public func thumbnails(for items: [VideoItem]) async -> [URL: UIImage] {
		var dict: [URL: UIImage] = [:]
		for item in items {
			if let img = thumbnail(for: item.url) {
				dict[item.url] = img
			}
		}
		return dict
	}
	
	private func enforceLimit() {
		let items = listVideos()
		guard items.count > maxVideos else { return }
		let toDelete = items.suffix(from: maxVideos)
		for item in toDelete {
			try? fm.removeItem(at: item.url)
			thumbsCache.removeObject(forKey: item.url as NSURL)
		}
	}
	
	public func deleteAllVideos() async {
		let items = listVideos()
		for item in items {
			try? fm.removeItem(at: item.url)
			thumbsCache.removeObject(forKey: item.url as NSURL)
		}
	}
	
	public func deleteVideo(at url: URL) async {
		try? fm.removeItem(at: url)
		thumbsCache.removeObject(forKey: url as NSURL)
	}
}

public extension VideoFileService {
	@discardableResult
	func writeGameMetadata(
		to inputURL: URL,
		playerName: String,
		gameScore: Int
	) async throws -> URL {
		let asset = AVURLAsset(url: inputURL)
		
		guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
			throw NSError(domain: "VideoFileService", code: -11, userInfo: [NSLocalizedDescriptionKey: "Cannot create exporter"])
		}
		
		let outURL: URL = {
			let base = inputURL.deletingPathExtension().lastPathComponent
			let dir  = inputURL.deletingLastPathComponent()
			return dir.appendingPathComponent(base + "_meta").appendingPathExtension("mov")
		}()
		
		try? FileManager.default.removeItem(at: outURL)
		
		func makeMdtaItem(key: String, value: String) -> AVMutableMetadataItem {
			let item = AVMutableMetadataItem()
			item.keySpace  = .quickTimeMetadata
			item.identifier = AVMetadataIdentifier("mdta/\(key)")
			item.value     = value as (NSCopying & NSObjectProtocol)
			item.dataType  = kCMMetadataBaseDataType_UTF8 as String
			return item
		}
		
		let playerNameItem = makeMdtaItem(key: "com.ai.charades.playerName", value: playerName)
		let gameScoreItem  = makeMdtaItem(key: "com.ai.charades.gameScore",  value: String(gameScore))
		
		var fileMetadata = asset.metadata
		
		let ourIds: Set<AVMetadataIdentifier> = [
			AVMetadataIdentifier("mdta/com.ai.charades.playerName"),
			AVMetadataIdentifier("mdta/com.ai.charades.gameScore")
		]
		fileMetadata.removeAll { item in
			guard let id = item.identifier else { return false }
			return ourIds.contains(id)
		}
		
		fileMetadata.append(contentsOf: [playerNameItem, gameScoreItem])
		
		exporter.outputURL = outURL
		if exporter.supportedFileTypes.contains(.mov) {
			exporter.outputFileType = .mov
		} else {
			exporter.outputFileType = exporter.supportedFileTypes.first
		}
		exporter.metadata = fileMetadata
		exporter.shouldOptimizeForNetworkUse = false
		
		try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
			exporter.exportAsynchronously {
				switch exporter.status {
				case .completed:
					continuation.resume()
				case .failed, .cancelled:
					let err = exporter.error ?? NSError(domain: "VideoFileService", code: -12, userInfo: [NSLocalizedDescriptionKey: "Export failed"])
					continuation.resume(throwing: err)
				default:
					let err = exporter.error ?? NSError(domain: "VideoFileService", code: -13, userInfo: [NSLocalizedDescriptionKey: "Export not completed"])
					continuation.resume(throwing: err)
				}
			}
		}
		
		return outURL
	}
	
	func readGameMetadata(from url: URL) async -> (playerName: String, gameScore: Int)? {
		let asset = AVURLAsset(url: url)
		let qt = asset.metadata(forFormat: .quickTimeMetadata)
		
		func value(for id: String) -> String? {
			qt.first(where: { $0.identifier?.rawValue == id })?.stringValue
		}
		
		guard
			let playerName = value(for: "mdta/com.ai.charades.playerName"),
			let scoreStr = value(for: "mdta/com.ai.charades.gameScore"),
			let score = Int(scoreStr)
		else { return nil }
		
		return (playerName, score)
	}
}

private extension AVMetadataItem {
	var stringValue: String? {
		if let s = value as? String { return s }
		if let d = value as? Data   { return String(data: d, encoding: .utf8) }
		if let n = value as? NSNumber { return n.stringValue }
		return nil
	}
}

//
//  AVSpeechSynthesisVoice+FilteredVoices.swift
//  AI-Charades-UI
//
//  Created by Oleksandr Yakobshe on 29.10.2025.
//

import AVFAudio

public extension AVSpeechSynthesisVoice {
	// MARK: - Methods
	
	func getVoice(for languageCode: String, gender: AVSpeechSynthesisVoiceGender) -> AVSpeechSynthesisVoice? {
		let primaryGender: AVSpeechSynthesisVoiceGender = gender
		let secondaryGender: AVSpeechSynthesisVoiceGender = gender == .female ? .male : .female
		
		var code = languageCode
		let voices = AVSpeechSynthesisVoice.speechVoices()
		let sortedVoices = voices.sorted { $0.name < $1.name }
		let filteredVoices = sortedVoices.filter { $0.language.starts(with: code) }
		
		var filteredPremiumVoices = filterBuyQuality(
			filteredVoices: filteredVoices,
			isPremium: true
		)
		if filteredPremiumVoices.isEmpty {
			filteredPremiumVoices = filterBuyQuality(
				filteredVoices: filteredVoices,
				isPremium: false
			)
		}
		if filteredPremiumVoices.isEmpty {
			filteredPremiumVoices = filteredVoices
		}
		var filteredGenderVoices = filterBuyGender(
			filteredVoices: filteredPremiumVoices,
			gender: primaryGender
		)
		if filteredGenderVoices.isEmpty {
			filteredGenderVoices = filterBuyGender(
				filteredVoices: filteredPremiumVoices,
				gender: secondaryGender
			)
		}
		if filteredGenderVoices.isEmpty {
			filteredGenderVoices = filteredPremiumVoices
		}
		return filteredGenderVoices.first
	}
	
	// MARK: - Private methods
	
	private func filterBuyQuality(
		filteredVoices: [AVSpeechSynthesisVoice],
		isPremium: Bool
	) -> [AVSpeechSynthesisVoice] {
		return filteredVoices.filter {
			if #available(iOS 16.0, *) {
				if isPremium {
					$0.quality == .premium
				} else {
					$0.quality == .enhanced
				}
			} else {
				$0.quality == .enhanced
			}
		}
	}
	
	private func filterBuyGender(
		filteredVoices: [AVSpeechSynthesisVoice],
		gender: AVSpeechSynthesisVoiceGender
	) -> [AVSpeechSynthesisVoice] {
		return filteredVoices.filter {
			if #available(iOS 16.0, *) {
				$0.gender == gender
			} else {
				$0.gender == gender
			}
		}
	}
}

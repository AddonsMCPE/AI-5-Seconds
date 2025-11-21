//
//  AVAccess.swift
//  AI-Charades-Services
//
//  Created by Anna Radchenko on 05.10.2025.
//

import UIKit
import AI_Charades_UI
import AVFoundation

public enum AVAccessResult {
	case grantedBoth
	case deniedCamera
	case deniedMicrophone
}

public enum AVSimpleStatus {
	case authorized
	case notDetermined
	case deniedOrRestricted
}

public final class AVAccess {
	// MARK: - Properties
	
	public static var isBothAuthorized: Bool {
		cameraStatus() == .authorized && microphoneStatus() == .authorized && UserDefaults.isGameRecordTurnOn
	}
	
	// MARK: - Methods
	
	public static func ensureCameraThenMicrophone(_ completion: @escaping (AVAccessResult) -> Void) {
		let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
		switch cameraStatus {
		case .authorized:
			requestMicrophone(completion)
		case .notDetermined:
			AVCaptureDevice.requestAccess(for: .video) { granted in
				if granted {
					requestMicrophone(completion)
				} else {
					DispatchQueue.main.async { completion(.deniedCamera) }
				}
			}
		case .denied, .restricted:
			DispatchQueue.main.async { completion(.deniedCamera) }
		@unknown default:
			DispatchQueue.main.async { completion(.deniedCamera) }
		}
	}
	
	// MARK: - Private methods
	
	private static func requestMicrophone(_ completion: @escaping (AVAccessResult) -> Void) {
		let audioPermission = AVAudioSession.sharedInstance().recordPermission
		switch audioPermission {
		case .granted:
			DispatchQueue.main.async { completion(.grantedBoth) }
		case .undetermined:
			AVAudioSession.sharedInstance().requestRecordPermission { granted in
				DispatchQueue.main.async {
					completion(granted ? .grantedBoth : .deniedMicrophone)
				}
			}
		case .denied:
			DispatchQueue.main.async { completion(.deniedMicrophone) }
		@unknown default:
			DispatchQueue.main.async { completion(.deniedMicrophone) }
		}
	}
	
	private static func cameraStatus() -> AVSimpleStatus {
		switch AVCaptureDevice.authorizationStatus(for: .video) {
		case .authorized:
			return .authorized
		case .notDetermined:
			return .notDetermined
		case .denied, .restricted:
			return .deniedOrRestricted
		@unknown default:
			return .deniedOrRestricted
		}
	}
	
	private static func microphoneStatus() -> AVSimpleStatus {
		switch AVAudioSession.sharedInstance().recordPermission {
		case .granted:
			return .authorized
		case .undetermined:
			return .notDetermined
		case .denied:
			return .deniedOrRestricted
		@unknown default:
			return .deniedOrRestricted
		}
	}
}

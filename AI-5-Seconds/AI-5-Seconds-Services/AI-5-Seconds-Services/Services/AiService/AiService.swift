//
//  AiService.swift
//  IA_Minecraft-Services
//
//  Created by Anna Radchenko on 06.08.2025.
//

import SwiftyJSON

public enum AiError: Error {
	case parameterWrong
	case networkFailed
	case invalidResponse
}

public enum AiResult {
	case getReady(_ text: String)
	case error(_ error: AiError)
}

enum AiEditorState {
	case ready(_ text: String)
	case error
}

public class AiService {
	// MARK: - Public properties
	
	public typealias Observer = (AiResult) -> ()
	public var observer: Observer?
	
	// MARK: - Private properties
	
	private var openAiTask: URLSessionDataTask?
	private var state: AiEditorState = .error {
		didSet {
			switch state {
			case .ready(let text):
				observer?(.getReady(text))
			case .error:
				observer?(.error(.invalidResponse))
			}
		}
	}
	
	// MARK: - Public methods
	
	public func stopOpenAiRequest() {
		openAiTask?.cancel()
		openAiTask = nil
	}
	
	public func startOpenAiEditing(prompt: String) {
		requestAi(prompt: prompt)
	}
	
	// MARK: - Private methods
	
	private func requestAi(prompt: String) {
		requestOpenAi(
			prompt,
			"gpt-4o-mini",
			0.6,
			complete: { result in
				switch result {
				case let .success(targetText):
					self.state = .ready(targetText)
				case .failure:
					self.state = .error
				}
			}
		)
	}
	
	private func createRequest(prompt: String, isStream: Bool = true) throws -> URLRequest {
		let messages: [[String: Any]] = [
			[
				"role": "user",
				"content": prompt
			]
		]
		var json: [String: Any] = [
			"model": "gpt-4o-mini",
			"messages": messages,
		]
		
		json["temperature"] = 0.6
		json["max_tokens"] = 2000
		json["top_p"] = 0.6
		json["stream"] = isStream
		
		guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
			self.state = .error
			throw AiError.parameterWrong
		}
		let url = URL(string: "https://api.openai.com/v1/chat/completions")!
		
		let key = SecretsManager.getValue(for: "magic") ?? ""
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonData
		
		return request
	}
	
	private func checkResponse(_ rsp: URLResponse?) throws {
		guard let response = rsp as? HTTPURLResponse else {
			self.state = .error
			throw AiError.networkFailed
		}
		
		guard 200...299 ~= response.statusCode else {
			self.state = .error
			throw AiError.invalidResponse
		}
	}
}

// MARK: - AiService + Callback

private extension AiService {
	@discardableResult
	func requestOpenAi(_ prompt: String, _ openAiModel: String, _ temperature: Double, complete: @escaping (_ result: Result<String, Swift.Error>) -> Void) -> URLSessionDataTask? {
		
		let request: URLRequest
		do {
			request = try createRequest(prompt: prompt, isStream: false)
		} catch {
			complete(.failure(error))
			return nil
		}
		
		openAiTask = URLSession.shared.dataTask(with: request) { data, rsp, error in
			if let error = error {
				DispatchQueue.main.async { complete(.failure(error)) }
				return
			}
			
			do {
				try self.checkResponse(rsp)
			} catch {
				DispatchQueue.main.async { complete(.failure(error)) }
				return
			}
			if let data = data, let content = JSON(data)["choices"][0]["message"]["content"].string {
				DispatchQueue.main.async { complete(.success(content)) }
			} else {
				DispatchQueue.main.async { complete(.success("")) }
			}
		}
		
		openAiTask?.resume()
		return openAiTask
	}
	
	func requestOpenAi(_ prompt: String, _ openAiModel: String, _ temperature: Double) async throws -> String {
		let request = try createRequest(prompt: prompt, isStream: false)
		
		let (data, rsp) = try await URLSession.shared.data(for: request)
		
		try checkResponse(rsp)
		if let content = JSON(data)["choices"][0]["message"]["content"].string {
				return content
		} else {
				return ""
		}
	}
}

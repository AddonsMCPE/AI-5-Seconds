import UIKit

extension UIBarMetrics: CaseIterable {
	public static var allCases: [Self] {
		return [.default, .defaultPrompt, .compact, .compactPrompt]
	}
}

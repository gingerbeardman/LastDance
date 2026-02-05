import Foundation

@objc protocol LastDanceHelperProtocol {
	func toggleFileSharing(enable: Bool, withReply reply: @escaping (Bool, String) -> Void)
}

enum HelperConstants {
	static let label = "com.gingerbeardman.LastDanceHelper"
}

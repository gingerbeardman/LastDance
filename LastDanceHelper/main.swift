import Foundation

final class Helper: NSObject, LastDanceHelperProtocol {
	func toggleFileSharing(enable: Bool, withReply reply: @escaping (Bool, String) -> Void) {
		let arguments: [String] = enable
			? ["load", "-w", "/System/Library/LaunchDaemons/com.apple.smbd.plist"]
			: ["unload", "-w", "/System/Library/LaunchDaemons/com.apple.smbd.plist"]
		let result = runLaunchctl(arguments: arguments)
		reply(result.exitCode == 0, result.output)
	}

	private func runLaunchctl(arguments: [String]) -> (exitCode: Int32, output: String) {
		let task = Process()
		task.executableURL = URL(fileURLWithPath: "/bin/launchctl")
		task.arguments = arguments

		let pipe = Pipe()
		task.standardOutput = pipe
		task.standardError = pipe

		do {
			try task.run()
			task.waitUntilExit()
		} catch {
			return (exitCode: 1, output: "Failed to run launchctl: \(error)")
		}

		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8) ?? ""
		return (exitCode: task.terminationStatus, output: output)
	}
}

final class HelperListenerDelegate: NSObject, NSXPCListenerDelegate {
	func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
		newConnection.exportedInterface = NSXPCInterface(with: LastDanceHelperProtocol.self)
		newConnection.exportedObject = Helper()
		newConnection.resume()
		return true
	}
}

let listener = NSXPCListener(machServiceName: HelperConstants.label)
let delegate = HelperListenerDelegate()
listener.delegate = delegate
listener.resume()
RunLoop.current.run()

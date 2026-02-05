import SwiftUI

@main
struct LastDanceApp: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	var body: some Scene {
		Settings {
			EmptyView()
		}
	}
}

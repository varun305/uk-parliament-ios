import SwiftUI

@main
struct UK_ParliamentApp: App {
    @StateObject var contextModel = ContextModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contextModel)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                ReviewManager.shared.recordLaunch()
            }
        }
    }
}

import SwiftUI

@main
struct UK_ParliamentApp: App {
    @StateObject var contextModel = ContextModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contextModel)
        }
    }
}

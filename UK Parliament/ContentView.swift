import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PartiesView()
                .tabItem {
                    Label("Parties", systemImage: "house")
                }

            Text("MPs")
                .tabItem {
                    Label("MPs", systemImage: "person.3.fill")
                }
        }
    }
}

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
                    Label("MPs and Lords", systemImage: "person.3.fill")
                }

            ConstituenciesView()
                .tabItem {
                    Label("Constituencies", systemImage: "map.fill")
                }
        }
    }
}

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    PartiesView()
                } label: {
                    Label("Parties", systemImage: "house")
                }

                NavigationLink {
                    MembersView()
                } label: {
                    Label("MPs and Lords", systemImage: "person.3.fill")
                }

                NavigationLink {
                    ConstituenciesView()
                } label: {
                    Label("Constituencies", systemImage: "map.fill")
                }
            }
            .navigationTitle("Home")
            
        }
    }
}

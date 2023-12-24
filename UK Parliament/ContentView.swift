import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        PartiesView()
                    } label: {
                        Label("Parties", systemImage: "house")
                    }

                    NavigationLink {
                        PostsView()
                    } label: {
                        Label("Posts", systemImage: "building.columns.fill")
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

                Section {
                    NavigationLink {
                        Text("Settings")
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

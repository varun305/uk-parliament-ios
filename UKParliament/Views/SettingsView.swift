import SwiftUI
import LicenseList

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        HelpView()
                    } label: {
                        Label("Help", systemImage: "questionmark")
                            .labelStyle(SquircleLabelStyle(color: .accentColor))
                    }
                }

                Section {
                    NavigationLink {
                        LicenseListView()
                            .licenseViewStyle(.withRepositoryAnchorLink)
                            .navigationTitle("Licences")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Label("Licences", image: "licence")
                            .labelStyle(SquircleLabelStyle(color: .accentColor))
                    }

                    Link(destination: URL(string: "https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/")!) {
                        Label("Open parliament licence", systemImage: "link")
                            .labelStyle(SquircleLabelStyle(color: .accentColor))
                    }
                    .tint(.primary)
                } footer: {
                    Text("This app makes use of the UK Parliament API. Check out their licence for more information.")
                }

                Section {
                    Link(destination: URL(string: "https://github.com/varun305/uk-parliament-ios")!) {
                        Label("GitHub repository", image: "github.logo")
                            .labelStyle(SquircleLabelStyle(color: .black))
                    }
                    .tint(.primary)
                } footer: {
                    Text("This app is open-source! Check out the GitHub repository to view and contribute!")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

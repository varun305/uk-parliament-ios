import SwiftUI
import LicenseList

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    let faqItems = [
        FAQItem(
            question: "How can I find my constituency?",
            answer: "You can locate your constituency by selecting the \"Constituencies\" page from the home screen and entering your postcode in the search bar"
        ),
        FAQItem(
            question: "How can I check how my MP voted?",
            answer: "To see how your MP voted, navigate to the \"MPs\" page, search for and select your MP, then click on \"Commons votes\""
        ),
        FAQItem(
            question: "How can I access the latest version of a bill?",
            answer: "To view the latest version of a bill, go to the \"Bills\" page, search for the bill you are interested in, select it, and then click on \"All publications\""
        )
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        helpView
                    } label: {
                        Label("Help", systemImage: "questionmark")
                            .labelStyle(SquircleLabelStyle(color: .accentColor))
                    }
                }
                
                Section {
                    NavigationLink {
                        LicenseListView()
                            .licenseListViewStyle(.withRepositoryAnchorLink)
                            .navigationTitle("Licences")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Label("Licences", image: "licence")
                            .labelStyle(SquircleLabelStyle(color: .accentColor))
                    }
                    
                    Link(destination: URL(string: "https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/")!) {
                        Label("UK Parliament API", systemImage: "link")
                            .labelStyle(SquircleLabelStyle(color: .accentColor))
                    }
                }
                
                Section {
                    Link(destination: URL(string: "https://github.com/varun305/uk-parliament-ios")!) {
                        Label("GitHub repository", image: "github.logo")
                            .labelStyle(SquircleLabelStyle(color: .black))
                    }
                } footer: {
                    Text("This app is open-source ")
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
    
    @ViewBuilder
    var helpView: some View {
        List {
            Section {
                ForEach(faqItems) { faqItem in
                    DisclosureGroup(faqItem.question) {
                        Text(faqItem.answer)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FAQItem: Identifiable {
    var question: String
    var answer: String
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
    
    var id: String {
        question + answer
    }
}

#Preview {
    SettingsView()
}

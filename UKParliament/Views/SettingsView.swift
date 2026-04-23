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

// MARK: - Help View

struct HelpView: View {
    var body: some View {
        List {
            Section {
                HelpTipRow(
                    icon: "magnifyingglass",
                    iconColor: .accentColor,
                    title: "Search from Home",
                    detail: "Use the search bar on the home screen to quickly find any section of the app by name."
                )
                HelpTipRow(
                    icon: "hand.tap.fill",
                    iconColor: .accentColor,
                    title: "Tap to explore",
                    detail: "Tap on any member, bill, or constituency to see full details, voting history, and more."
                )
            } header: {
                HelpSectionHeader(title: "Getting started", systemImage: "star.fill")
            }

            Section {
                HelpFAQRow(
                    question: "How do I find my MP?",
                    answer: "Go to \"MPs\" from the home screen. You can scroll through the list or use the search bar to find your MP by name."
                )
                HelpFAQRow(
                    question: "How do I find my Lord?",
                    answer: "Go to \"Lords\" from the home screen. Use the search bar to find a Lord by name."
                )
                HelpFAQRow(
                    question: "How can I check how my MP voted?",
                    answer: "Navigate to \"MPs\", search for and select your MP, then tap \"Commons votes\" to see their full voting record."
                )
                HelpFAQRow(
                    question: "How do I contact my MP?",
                    answer: "Find your MP in the \"MPs\" section, tap on their profile, then tap \"Contact\" to see their email, phone, and office addresses."
                )
                HelpFAQRow(
                    question: "What are registered interests?",
                    answer: "Registered interests are financial and non-financial interests that members are required to declare. View them by tapping \"Registered interests\" on a member's profile."
                )
            } header: {
                HelpSectionHeader(title: "Members", systemImage: "person.2.fill")
            }

            Section {
                HelpFAQRow(
                    question: "How do I find my constituency?",
                    answer: "Go to \"Constituencies\" from the home screen and enter your postcode in the search bar to find your constituency."
                )
                HelpFAQRow(
                    question: "Can I see past election results?",
                    answer: "Yes! Select a constituency to view its details, then tap on an election to see the full breakdown of results by candidate and party."
                )
            } header: {
                HelpSectionHeader(title: "Constituencies", systemImage: "map.fill")
            }

            Section {
                HelpFAQRow(
                    question: "How do I look up a bill?",
                    answer: "Go to \"Bills\" from the home screen and use the search bar to find a bill by title or keyword."
                )
                HelpFAQRow(
                    question: "How can I read the latest version of a bill?",
                    answer: "Find and select the bill you're interested in, then tap \"All publications\" to access the full text and related documents."
                )
                HelpFAQRow(
                    question: "What are bill stages?",
                    answer: "Bills pass through several stages in Parliament (e.g. First Reading, Second Reading, Committee Stage). Tap \"Stages\" on a bill to see its progress through these stages."
                )
                HelpFAQRow(
                    question: "How do I see amendments to a bill?",
                    answer: "Navigate to a bill's stages, select a specific stage, then tap \"Amendments\" to view proposed changes."
                )
            } header: {
                HelpSectionHeader(title: "Bills & legislation", systemImage: "doc.text.fill")
            }

            Section {
                HelpFAQRow(
                    question: "What's the difference between Commons and Lords votes?",
                    answer: "Commons votes are decisions made by MPs in the House of Commons. Lords votes are decisions made by members of the House of Lords. Each house votes separately on legislation."
                )
                HelpFAQRow(
                    question: "How do I see who voted for or against?",
                    answer: "Open a vote from the Commons or Lords votes section. You'll see a breakdown of Ayes and Noes with the full list of members who voted each way."
                )
            } header: {
                HelpSectionHeader(title: "Votes", systemImage: "checkmark.circle.fill")
            }

            Section {
                HelpFAQRow(
                    question: "What are government and opposition posts?",
                    answer: "Posts are official roles held by members, such as cabinet ministers, shadow cabinet members, and other parliamentary positions. Browse them in the \"Posts\" section."
                )
                HelpFAQRow(
                    question: "What does State of the Parties show?",
                    answer: "The \"Parties\" section shows the current composition of both Houses, including how many seats each party holds in the Commons and Lords."
                )
            } header: {
                HelpSectionHeader(title: "Posts & parties", systemImage: "briefcase.fill")
            }

            Section {
                HelpTipRow(
                    icon: "globe",
                    iconColor: .secondary,
                    title: "Data source",
                    detail: "All data is sourced live from the official UK Parliament API (api.parliament.uk)."
                )
            } header: {
                HelpSectionHeader(title: "Good to know", systemImage: "lightbulb.fill")
            }
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Help Section Header

private struct HelpSectionHeader: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.subheadline.weight(.semibold))
            .textCase(nil)
    }
}

// MARK: - Help Tip Row

private struct HelpTipRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(iconColor)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Help FAQ Row

private struct HelpFAQRow: View {
    let question: String
    let answer: String

    var body: some View {
        DisclosureGroup {
            Text(answer)
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.top, 2)
        } label: {
            Text(question)
                .font(.subheadline)
        }
    }
}

#Preview {
    SettingsView()
}

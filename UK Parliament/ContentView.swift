import SwiftUI

struct ContentView: View {
    @EnvironmentObject var contextModel: ContextModel
    @Environment(\.openURL) var openURL

    var body: some View {
        NavigationStack(path: $contextModel.navigationPath) {
            List {
                Section {
                    ContextAwareNavigationLink(value: .billsView(member: nil)) {
                        BillsViewRow()
                    }

                    ContextAwareNavigationLink(value: .commonsVotesView) {
                        CommonsVotesViewRow()
                    }

                    ContextAwareNavigationLink(value: .lordsVotesView) {
                        LordsVotesViewRow()
                    }

                    ContextAwareNavigationLink(value: .membersView) {
                        MembersViewRow()
                    }

                    ContextAwareNavigationLink(value: .constituenciesView) {
                        ConstituenciesViewRow()
                    }

                    ContextAwareNavigationLink(value: .postsView) {
                        Label("Posts", systemImage: "building.columns.fill")
                    }

                    ContextAwareNavigationLink(value: .partiesView) {
                        Label("Parties", systemImage: "house")
                    }
                }

                Section {
                    Button {
                        openURL(URL(string: "https://www.parliament.uk/")!)
                    } label: {
                        Label("UK Parliament website", systemImage: "link.circle")
                    }
                    NavigationLink("Acknowledgements") {
                        AcknowledgementsView()
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Home")
            .navigationDestination(for: NavigationItem.self) { item in
                switch item {
                case ._404:
                    Text("Oops! This page doesn't exist")
                case .partiesView:
                    PartiesView()
                case .membersView:
                    MembersView()
                case .memberDetailView(let memberId):
                    MemberDetailView(memberId: memberId)
                case .memberContactView(let member):
                    MemberContactView(member: member)
                case .memberInterestsView(let member):
                    RegisteredInterestsView(member: member)
                case .constituenciesView:
                    ConstituenciesView()
                case .constituencyDetailView(let constituency):
                    ConstituencyDetailView(constituency: constituency)
                case .constituencyElectionDetailView(let constituency, let election):
                    ConstituencyElectionDetailView(constituency: constituency, electionResult: election)
                case .postsView:
                    PostsView()
                case .billsView(let member):
                    BillsView(viewModel: BillsViewModel(member: member))
                case .billDetailView(let bill):
                    BillDetailView(bill: bill)
                case .billStagesView(let bill):
                    BillStagesView(bill: bill)
                case .billStageSittingsView(let stage):
                    BillStageSittingsView(stage: stage)
                case .billAmendmentsView(let bill, let stage):
                    BillAmendmentsView(bill: bill, stage: stage)
                case .billPublicationsView(let bill, let stage):
                    BillPublicationsView(bill: bill, stage: stage)
                case .billPublicationLinksView(let publication):
                    BillPublicationLinksView(publication: publication)
                case .commonsVotesView:
                    CommonsVotesView()
                case .commonsVoteDetailView(let vote):
                    CommonsVoteDetailView(vote: vote)
                case .memberCommonsVotesView(let member):
                    MemberCommonsVotesView(viewModel: MemberCommonsVotesViewModel(member: member))
                case .lordsVotesView:
                    LordsVotesView()
                case .lordsVoteDetailView(let vote):
                    LordsVoteDetailView(vote: vote)
                }
            }
        }
        .textSelection(.enabled)
    }
}

private struct CommonsVotesViewRow: View {
    var body: some View {
        HStack(alignment: .center) {
            Image("commons")
                .resizable()
                .frame(width: 60, height: 60)
                .mask {
                    Circle()
                        .frame(width: 60, height: 60)
                }
            VStack(alignment: .leading) {
                Text("Commons votes")
                    .bold()
                Text("View and filter the results of votes in the House of Commons")
                    .font(.caption)
            }
        }
    }
}

private struct LordsVotesViewRow: View {
    var body: some View {
        HStack(alignment: .center) {
            Image("lords")
                .resizable()
                .frame(width: 60, height: 60)
                .mask {
                    Circle()
                        .frame(width: 60, height: 60)
                }
            VStack(alignment: .leading) {
                Text("Lords votes")
                    .bold()
                Text("View and filter the results of votes in the House of Lords")
                    .font(.caption)
            }
        }
    }
}

private struct BillsViewRow: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "doc.circle")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(.accent)
            VStack(alignment: .leading) {
                Text("Bills")
                    .bold()
                Text("View bills, stages and publications")
                    .font(.caption)
            }
        }
    }
}

private struct MembersViewRow: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.bust.circle")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(.accent)
            VStack(alignment: .leading) {
                Text("MPs and Lords")
                    .bold()
                Text("View and search for MPs and Lords")
                    .font(.caption)
            }
        }
    }
}

private struct ConstituenciesViewRow: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "map.circle")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(.accent)
            VStack(alignment: .leading) {
                Text("Constituencies")
                    .bold()
                Text("View and search for constituencies")
                    .font(.caption)
            }
        }
    }
}

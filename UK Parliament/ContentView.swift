import SwiftUI

struct ContentView: View {
    @EnvironmentObject var contextModel: ContextModel

    var body: some View {
        NavigationStack(path: $contextModel.navigationPath) {
            List {
                ContextAwareNavigationLink(value: .commonsVotesView) {
                    Label("Commons votes", systemImage: "checkmark.square")
                }
                ContextAwareNavigationLink(value: .billsView(member: nil)) {
                    Label("Bills", systemImage: "square.on.square")
                }

                ContextAwareNavigationLink(value: .membersView) {
                    Label("MPs and Lords", systemImage: "person.3.fill")
                }

                ContextAwareNavigationLink(value: .constituenciesView) {
                    Label("Constituencies", systemImage: "map.fill")
                }

                ContextAwareNavigationLink(value: .postsView) {
                    Label("Posts", systemImage: "building.columns.fill")
                }

                ContextAwareNavigationLink(value: .partiesView) {
                    Label("Parties", systemImage: "house")
                }
            }
            .navigationTitle("Home")
            .navigationDestination(for: NavigationItem.self) { item in
                switch item {
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
                    BillsView(member: member)
                case .billDetailView(let bill):
                    BillDetailView(bill: bill)
                case .billStagesView(let bill):
                    BillStagesView(bill: bill)
                case .billPublicationsView(let bill, let stage):
                    BillPublicationsView(bill: bill, stage: stage)
                case .billPublicationLinksView(let links):
                    BillPublicationLinksView(links: links)
                case .commonsVotesView:
                    CommonsVotesView()
                case .commonsVoteDetailView(let vote):
                    CommonsVoteDetailView(vote: vote)
                }
            }
        }
    }
}

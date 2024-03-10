import SwiftUI

struct ContentView: View {
    @EnvironmentObject var contextModel: ContextModel

    var body: some View {
        NavigationStack(path: $contextModel.navigationPath) {
            ScrollView {
                VStack(alignment: .leading) {
                    EndpointsView()
                }
                .padding(.top, 20)
            }
            .navigationTitle("Home")
            .listStyle(.grouped)
            .navigationDestination(for: NavigationItem.self) { item in
                switch item {
                case ._404:
                    Text("Oops! This page doesn't exist")
                case .partiesView:
                    PartiesView()
                case .mpsView:
                    MembersView(viewModel: MembersViewModel(house: .commons))
                case .lordsView:
                    MembersView(viewModel: MembersViewModel(house: .lords))
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
                    BillStagesView(viewModel: BillStagesViewModel(bill: bill))
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
                case .memberLordsVotesView(let member):
                    MemberLordsVotesView(viewModel: MemberLordsVotesViewModel(member: member))
                }
            }
        }
        .textSelection(.enabled)
    }
}

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var contextModel: ContextModel

    @State private var countrySheetShown = false
    var navTitle: String {
        switch contextModel.country {
        case .unitedKingdom:
            return "UK parliament"
        case .scotland:
            return "Scottish parliament"
        }
    }

    var body: some View {
        NavigationStack(path: $contextModel.navigationPath) {
            ScrollView {
                VStack(alignment: .leading) {
                    switch contextModel.country {
                    case .unitedKingdom:
                        UKPagesView()
                    case .scotland:
                        Text("SCOTLAND")
                    }
                }
                .padding(.top, 20)
            }
            .navigationTitle(navTitle)
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
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        countrySheetShown = true
                    } label: {
                        switch contextModel.country {
                        case .unitedKingdom:
                            UKFlag()
                        case .scotland:
                            ScotlandFlag()
                        }
                    }
                }
            }
            .sheet(isPresented: $countrySheetShown) {
                countrySheet
            }
        }
        .textSelection(.enabled)
    }

    @ViewBuilder
    var countrySheet: some View {
        NavigationView {
            List {
                Button {
                    countrySheetShown = false
                    withAnimation {
                        contextModel.country = .unitedKingdom
                    }
                } label: {
                    ukRow
                }
                .foregroundStyle(.primary)

                Button {
                    countrySheetShown = false
                    withAnimation {
                        contextModel.country = .scotland
                    }
                } label: {
                    scotlandRow
                }
                .foregroundStyle(.primary)
            }
            .navigationTitle("Select country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        countrySheetShown = false
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }

    @ViewBuilder
    var ukRow: some View {
        HStack(spacing: 25) {
            UKFlag()
            Text("United Kingdom")
            if contextModel.country == .unitedKingdom {
                Spacer()
                Image(systemName: "checkmark")
            }
        }
    }

    @ViewBuilder
    var scotlandRow: some View {
        HStack(spacing: 25) {
            ScotlandFlag()
            Text("Scotland")
            if contextModel.country == .scotland{
                Spacer()
                Image(systemName: "checkmark")
            }
        }
    }
}

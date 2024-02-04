import SwiftUI

struct CommonsVoteDetailView: View {
    @StateObject var viewModel = CommonsVoteDetailViewModel()
    var vote: CommonsVote

    var body: some View {
        Group {
            if viewModel.vote != nil {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
            }
        }
        .ifLet(vote.title) { $0.navigationTitle("Votes, \($1)") }
        .onAppear {
            if let divisionId = vote.divisionId {
                viewModel.fetchData(for: divisionId)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                ForEach(0..<20) { _ in
                    NavigationLink {
                        Text("")
                    } label: {
                        VoterRowLoading()
                    }
                    .disabled(true)
                }
            }
        }
        .listStyle(.plain)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            if let ayeTellers = vote.ayeTellers, ayeTellers.count > 0 {
                Section("Aye tellers") {
                    ForEach(ayeTellers) { teller in
                        VoterNavigationLink(voter: teller)
                    }
                }
            }

            if let noTellers = vote.noTellers, noTellers.count > 0 {
                Section("No tellers") {
                    ForEach(noTellers) { teller in
                        VoterNavigationLink(voter: teller)
                    }
                }
            }

            if let ayes = viewModel.vote?.ayes, ayes.count > 0 {
                Section("Ayes") {
                    ForEach(ayes) { aye in
                        VoterNavigationLink(voter: aye)
                    }
                }
            }

            if let noes = viewModel.vote?.noes, noes.count > 0 {
                Section("Noes") {
                    ForEach(noes) { no in
                        VoterNavigationLink(voter: no)
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private struct VoterNavigationLink: View {
        var voter: Voter
        var body: some View {
            if let memberId = voter.memberId {
                ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                    VoterRow(voter: voter)
                }
            } else {
                VoterRow(voter: voter)
            }
        }
    }
}

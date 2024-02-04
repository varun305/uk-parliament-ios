import SwiftUI

struct LordsVoteDetailView: View {
    @StateObject var viewModel = LordsVoteDetailViewModel()
    var vote: LordsVote

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
            if let contentTellers = viewModel.vote?.contentTellers, contentTellers.count > 0 {
                Section("Content tellers") {
                    ForEach(contentTellers) { teller in
                        VoterNavigationLink(voter: teller)
                    }
                }
            }

            if let notContentTellers = viewModel.vote?.notContentTellers, notContentTellers.count > 0 {
                Section("Not content tellers") {
                    ForEach(notContentTellers) { teller in
                        VoterNavigationLink(voter: teller)
                    }
                }
            }

            if let contents = viewModel.vote?.contents, contents.count > 0 {
                Section("Contents") {
                    ForEach(contents) { aye in
                        VoterNavigationLink(voter: aye)
                    }
                }
            }

            if let notContents = viewModel.vote?.notContents, notContents.count > 0 {
                Section("Not contents") {
                    ForEach(notContents) { no in
                        VoterNavigationLink(voter: no)
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private struct VoterNavigationLink: View {
        var voter: LordsVoter
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

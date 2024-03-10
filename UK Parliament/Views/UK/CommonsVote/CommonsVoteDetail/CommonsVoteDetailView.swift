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
        .listStyle(.grouped)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            if let ayeCount = vote.ayeCount, let noCount = vote.noCount {
                HStack(alignment: .center) {
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.secondary)
                        Text("\(ayeCount)")
                            .font(.title)
                            .if(ayeCount > noCount) { $0.bold() }
                    }
                    Spacer()
                    HStack {
                        Text("\(noCount)")
                            .font(.title)
                            .if(ayeCount < noCount) { $0.bold() }
                        Image(systemName: "hand.thumbsdown.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            }

            votesView
        }
        .listStyle(.grouped)
    }

    @ViewBuilder
    var votesView: some View {
        if let ayeTellers = viewModel.vote?.ayeTellers, ayeTellers.count > 0 {
            Section("Aye tellers") {
                ForEach(ayeTellers) { teller in
                    VoterNavigationLink(voter: teller)
                }
            }
        }

        if let noTellers = viewModel.vote?.noTellers, noTellers.count > 0 {
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

    private struct VoterNavigationLink: View {
        var voter: CommonsVoter
        var body: some View {
            VoterRow(voter: voter)
                .ifLet(voter.memberId) { view, memberId in
                    ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                        view
                    }
                }
        }
    }
}

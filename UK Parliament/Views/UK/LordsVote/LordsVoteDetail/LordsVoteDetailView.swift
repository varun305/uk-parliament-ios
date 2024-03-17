import SwiftUI

struct LordsVoteDetailView: View {
    @StateObject var viewModel = LordsVoteDetailViewModel()
    @State fileprivate var viewOption = ViewOption.votes
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
        .listStyle(.grouped)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            if let authoritativeContentCount = vote.authoritativeContentCount, let authoritativeNotContentCount = vote.authoritativeNotContentCount {
                HStack(alignment: .center) {
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.secondary)
                        Text("\(authoritativeContentCount)")
                            .font(.title)
                            .if(authoritativeContentCount > authoritativeNotContentCount) { $0.bold() }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text("Contents \(authoritativeContentCount)"))
                    Spacer()
                    HStack {
                        Text("\(authoritativeNotContentCount)")
                            .font(.title)
                            .if(authoritativeContentCount < authoritativeNotContentCount) { $0.bold() }
                        Image(systemName: "hand.thumbsdown.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text("Not contents \(authoritativeNotContentCount)"))
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

    private struct VoterNavigationLink: View {
        var voter: LordsVoter
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

private enum ViewOption { case party, votes }

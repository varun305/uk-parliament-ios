import SwiftUI

struct CommonsVoteDetailView: View {
    @StateObject var viewModel = CommonsVoteDetailViewModel()
    var vote: CommonsVote

    var body: some View {
        Group {
            if let vote = viewModel.vote {
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

                    if let ayes = vote.ayes, ayes.count > 0 {
                        Section("Ayes") {
                            ForEach(ayes) { aye in
                                VoterNavigationLink(voter: aye)
                            }
                        }
                    }

                    if let noes = vote.noes, noes.count > 0 {
                        Section("Noes") {
                            ForEach(noes) { no in
                                VoterNavigationLink(voter: no)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .ifLet(vote.title) { $0.navigationTitle("Votes, \($1)") }
            } else {
                Text("No data")
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
        .onAppear {
            if let divisionId = vote.divisionId {
                viewModel.fetchData(for: divisionId)
            }
        }
    }

    private struct VoterNavigationLink: View {
        var voter: CommonsVoter
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

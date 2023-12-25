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
                                ContextAwareNavigationLink(value: .memberDetailView(memberId: teller.memberId)) {
                                    VoterRow(voter: teller)
                                }
                            }
                        }
                    }

                    if let noTellers = vote.noTellers, noTellers.count > 0 {
                        Section("No tellers") {
                            ForEach(noTellers) { teller in
                                ContextAwareNavigationLink(value: .memberDetailView(memberId: teller.memberId)) {
                                    VoterRow(voter: teller)
                                }
                            }
                        }
                    }

                    if vote.ayes.count > 0 {
                        Section("Ayes") {
                            ForEach(vote.ayes) { aye in
                                ContextAwareNavigationLink(value: .memberDetailView(memberId: aye.memberId)) {
                                    VoterRow(voter: aye)
                                }
                            }
                        }
                    }

                    if vote.noes.count > 0 {
                        Section("Noes") {
                            ForEach(vote.noes) { no in
                                ContextAwareNavigationLink(value: .memberDetailView(memberId: no.memberId)) {
                                    VoterRow(voter: no)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Votes, \(vote.title)")
            } else {
                Text("No data")
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
        .onAppear {
            viewModel.fetchData(for: vote.divisionId)
        }
    }
}

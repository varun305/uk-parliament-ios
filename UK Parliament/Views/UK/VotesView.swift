import SwiftUI

struct VotesView: View {
    var allVotesModel: AllVotesModel

    var body: some View {
        List {
            votesView
        }
        .listStyle(.plain)
        .navigationTitle("All votes, \(allVotesModel.title ?? "")")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    var votesView: some View {
        if let yesTellers = allVotesModel.yesVoteTellers, yesTellers.count > 0 {
            Section(allVotesModel.house == .commons ? "Aye tellers" : "Content tellers") {
                ForEach(yesTellers.sorted { $0.listAs ?? "" < $1.listAs ?? "" }, id: \.memberId) { teller in
                    voterNavigationLink(teller)
                }
            }
        }

        if let noTellers = allVotesModel.noVoteTellers, noTellers.count > 0 {
            Section(allVotesModel.house == .commons ? "No tellers" : "Not content tellers") {
                ForEach(noTellers.sorted { $0.listAs ?? "" < $1.listAs ?? "" }, id: \.memberId) { teller in
                    voterNavigationLink(teller)
                }
            }
        }

        if let yesVotes = allVotesModel.yesVotes, yesVotes.count > 0 {
            Section(allVotesModel.house == .commons ? "Ayes" : "Contents") {
                ForEach(yesVotes.sorted { $0.listAs ?? "" < $1.listAs ?? "" }, id: \.memberId) { aye in
                    voterNavigationLink(aye)
                }
            }
        }

        if let noVotes = allVotesModel.noVotes, noVotes.count > 0 {
            Section(allVotesModel.house == .commons ? "Noes" : "Not contents") {
                ForEach(noVotes.sorted { $0.listAs ?? "" < $1.listAs ?? "" }, id: \.memberId) { no in
                    voterNavigationLink(no)
                }
            }
        }
    }

    @ViewBuilder
    private func voterNavigationLink(_ voter: any Voter) -> some View {
        VoterRow(voter: voter)
            .ifLet(voter.memberId) { view, memberId in
                ContextAwareNavigationLink(value: .memberDetailView(memberId: memberId)) {
                    view
                }
            }
    }
}

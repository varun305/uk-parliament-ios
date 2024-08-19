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
        .searchable(text: $search)
    }

    @State private var search = ""

    private var yesTellers: [any Voter] {
        allVotesModel.yesVoteTellers?.filter {
            $0.name?.searchContains(search) ?? false
        } ?? []
    }

    private var noTellers: [any Voter] {
        allVotesModel.noVoteTellers?.filter {
            $0.name?.searchContains(search) ?? false
        } ?? []
    }

    private var yesVotes: [any Voter] {
        allVotesModel.yesVotes?.filter {
            $0.name?.searchContains(search) ?? false
        } ?? []
    }

    private var noVotes: [any Voter] {
        allVotesModel.noVotes?.filter {
            $0.name?.searchContains(search) ?? false
        } ?? []
    }

    @ViewBuilder
    var votesView: some View {
        if yesTellers.count > 0 {
            Section(allVotesModel.house == .commons ? "Aye tellers" : "Content tellers") {
                ForEach(yesTellers.sorted { $0.listAs ?? "" < $1.listAs ?? "" }, id: \.memberId) { teller in
                    voterNavigationLink(teller)
                }
            }
        }

        if noTellers.count > 0 {
            Section(allVotesModel.house == .commons ? "No tellers" : "Not content tellers") {
                ForEach(noTellers.sorted { $0.listAs ?? "" < $1.listAs ?? "" }, id: \.memberId) { teller in
                    voterNavigationLink(teller)
                }
            }
        }

        if yesVotes.count > 0 {
            Section(allVotesModel.house == .commons ? "Ayes" : "Contents") {
                ForEach(yesVotes.sorted { $0.listAs ?? "" < $1.listAs ?? "" }, id: \.memberId) { aye in
                    voterNavigationLink(aye)
                }
            }
        }

        if noVotes.count > 0 {
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

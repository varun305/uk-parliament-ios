import SwiftUI

struct LordsVotesView: View {
    @StateObject var viewModel = LordsVotesViewModel()
    var body: some View {
        UnifiedListView(
            viewModel: viewModel,
            rowView: { lordsVote in
                ContextAwareNavigationLink(value: .lordsVoteDetailView(vote: lordsVote)) {
                    LordsVoteRow(vote: lordsVote)
                }
            },
            navigationTitle: "Lords votes",
            showNumResults: false
        )
    }
}

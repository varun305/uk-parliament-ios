import SwiftUI

struct CommonsVotesView: View {
    @StateObject var viewModel = CommonsVotesViewModel()
    var body: some View {
        UnifiedListView(
            viewModel: viewModel,
            rowView: { commonsVote in
                ContextAwareNavigationLink(value: .commonsVoteDetailView(vote: commonsVote)) {
                    CommonsVoteRow(vote: commonsVote)
                }
            },
            rowLoadingView: {
                CommonsVoteRowLoading()
            },
            navigationTitle: "Commons vote",
            showNumResults: false
        )
    }
}

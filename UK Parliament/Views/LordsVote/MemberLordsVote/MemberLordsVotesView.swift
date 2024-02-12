import SwiftUI

struct MemberLordsVotesView: View {
    @StateObject var viewModel: MemberLordsVotesViewModel
    var body: some View {
        UnifiedListView(
            viewModel: viewModel,
            rowView: { memberLordsVote in
                MemberLordsVoteRow(memberVote: memberLordsVote)
                    .ifLet(memberLordsVote.publishedDivision) { view, memberLordsVote in
                        ContextAwareNavigationLink(value: .lordsVoteDetailView(vote: memberLordsVote)) {
                            view
                        }
                    }
            },
            rowLoadingView: {
                CommonsVoteRowLoading()
            },
            navigationTitle:  "Lords votes, \(viewModel.member.nameDisplayAs ?? "")",
            showNumResults: false
        )
    }
}

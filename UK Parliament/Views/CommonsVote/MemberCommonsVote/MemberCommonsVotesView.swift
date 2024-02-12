import SwiftUI

struct MemberCommonsVotesView: View {
    @StateObject var viewModel: MemberCommonsVotesViewModel
    var body: some View {
        UnifiedListView(
            viewModel: viewModel,
            rowView: { memberCommonsVote in
                MemberCommonsVoteRow(memberVote: memberCommonsVote)
                    .ifLet(memberCommonsVote.publishedDivision) { view, memberCommonsVote in
                        ContextAwareNavigationLink(value: .commonsVoteDetailView(vote: memberCommonsVote)) {
                            view
                        }
                    }
            },
            rowLoadingView: {
                CommonsVoteRowLoading()
            },
            navigationTitle: "Commons votes, \(viewModel.member.nameDisplayAs ?? "")"
        )
    }
}

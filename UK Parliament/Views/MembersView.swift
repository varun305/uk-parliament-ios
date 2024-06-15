import SwiftUI

struct MembersView: View {
    @StateObject var viewModel: MembersViewModel
    var body: some View {
        UnifiedListView(
            viewModel: viewModel,
            rowView: { member in
                MemberRow(member: member)
                    .ifLet(member.id) { view, id in
                        ContextAwareNavigationLink(value: .memberDetailView(memberId: id)) {
                            view
                        }
                    }
            },
            rowLoadingView: {
                MemberRowLoading()
            },
            navigationTitle: viewModel.house == .commons ? "MPs" : "Lords"
        )
    }
}

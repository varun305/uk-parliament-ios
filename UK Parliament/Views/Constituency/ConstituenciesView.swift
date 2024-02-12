import SwiftUI

struct ConstituenciesView: View {
    var body: some View {
        UnifiedListView(
            viewModel: ConstituenciesViewModel(),
            rowView: { constituency in
                ContextAwareNavigationLink(value: .constituencyDetailView(constituency: constituency)) {
                    ConstituencyRow(consituency: constituency)
                }
            },
            rowLoadingView: {
                MemberRowLoading()
            },
            navigationTitle: "Constituencies"
        )
    }
}

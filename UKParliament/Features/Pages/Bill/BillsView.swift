import SwiftUI

struct BillsView: View {
    @StateObject var viewModel: BillsViewModel

    private var navTitle: String {
        if let name = viewModel.member?.nameDisplayAs {
            "Bills, \(name)"
        } else {
            "Bills"
        }
    }

    var body: some View {
        UnifiedListView(
            viewModel: viewModel,
            rowView: { bill in
                ContextAwareNavigationLink(value: .billDetailView(bill: bill)) {
                    BillRow(bill: bill)
                }
            },
            rowLoadingView: {
                BillRowLoading()
            },
            navigationTitle: navTitle
        )
    }
}

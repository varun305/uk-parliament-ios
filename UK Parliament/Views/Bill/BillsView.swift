import SwiftUI

struct BillsView: View {
    @StateObject var viewModel = BillsViewModel()
    @State var scrollItem: Bill.ID?

    var resultsText: String {
        "\(viewModel.numResults) results" + (viewModel.search != "" ? " for '\(viewModel.search)'" : "")
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text(resultsText)
                    .font(.caption)
                    .padding(.horizontal)
                Divider()
                ForEach(viewModel.bills) { bill in
                    NavigationLink {
                        BillDetailView(bill: bill)
                    } label: {
                        HStack {
                            BillRow(bill: bill)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    .foregroundStyle(.primary)
                    Divider()
                }
            }
            .scrollTargetLayout()
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search bills")
        .onSubmit(of: .search) {
            viewModel.nextData(reset: true)
        }
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(reset: true)
            }
        }
        .navigationTitle("Bills")
        .navigationBarTitleDisplayMode(.inline)
        .scrollPosition(id: $scrollItem, anchor: .bottom)
        .onChange(of: scrollItem) { _, new in
            if new == viewModel.bills.last?.id {
                viewModel.nextData()
            }
        }
        .onAppear {
            if viewModel.bills.isEmpty {
                viewModel.nextData(reset: true)
            }
        }
    }
}

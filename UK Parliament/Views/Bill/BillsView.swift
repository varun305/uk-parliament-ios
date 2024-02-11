import SwiftUI

struct BillsView: View {
    @StateObject var viewModel = BillsViewModel()

    var resultsText: String {
        "\(viewModel.totalResults) results"
    }

    var navTitle: String {
        if let nameDisplayAs = viewModel.member?.nameDisplayAs {
            "Bills, \(nameDisplayAs)"
        } else {
            "Bills"
        }
    }

    var body: some View {
        Group {
            if viewModel.loading && viewModel.items.isEmpty {
                loadingView
            } else if !viewModel.items.isEmpty {
                scrollView
            } else {
                NoDataView()
            }
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search bills")
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(reset: true)
            }
        }
        .navigationTitle(navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.nextData(reset: true)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                ForEach(0..<20) { _ in
                    DummyNavigationLink {
                        BillRowLoading()
                    }
                }
            }
        }
        .listStyle(.grouped)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            Section(resultsText) {
                ForEach(viewModel.items) { bill in
                    ContextAwareNavigationLink(value: .billDetailView(bill: bill)) {
                        BillRow(bill: bill)
                            .onAppear(perform: { onScrollEnd(bill: bill) })
                    }
                }
            }
        }
        .listStyle(.grouped)
    }

    private func onScrollEnd(bill: Bill) {
        if bill == viewModel.items.last {
            viewModel.nextData()
        }
    }
}

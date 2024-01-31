import SwiftUI

struct BillsView: View {
    @StateObject var viewModel = BillsViewModel()
    var member: Member?

    var resultsText: String {
        "\(viewModel.numResults) results" + (viewModel.search != "" ? " for '\(viewModel.search)'" : "")
    }

    var navTitle: String {
        if let nameDisplayAs = member?.nameDisplayAs {
            "Bills, \(nameDisplayAs)"
        } else {
            "Bills"
        }
    }

    var body: some View {
        Group {
            if viewModel.bills.count > 0 {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                Text("No data")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .italic()
            }
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search bills")
        .onSubmit(of: .search) {
            viewModel.nextData(memberId: member?.id, reset: true)
        }
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(memberId: member?.id, reset: true)
            }
        }
        .navigationTitle(navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.bills.isEmpty {
                viewModel.nextData(memberId: member?.id, reset: true)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List(0..<10) { _ in
            NavigationLink {
                Text("")
            } label: {
                BillRowLoading()
            }
            .disabled(true)
        }
        .listStyle(.plain)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            Section(resultsText) {
                ForEach(viewModel.bills) { bill in
                    ContextAwareNavigationLink(value: .billDetailView(bill: bill)) {
                        BillRow(bill: bill)
                            .onAppear(perform: { onScrollEnd(bill: bill) })
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private func onScrollEnd(bill: Bill) {
        if bill == viewModel.bills.last {
            viewModel.nextData(memberId: member?.id)
        }
    }
}

import SwiftUI

struct ConstituenciesView: View {
    @StateObject var viewModel = ConstituenciesViewModel()

    var resultsText: String {
        "\(viewModel.totalResults) results" + (viewModel.search != "" ? " for '\(viewModel.search)'" : "")
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
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Enter a name or postcode")
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(reset: true)
            }
        }
        .navigationTitle("Constituencies")
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
                ForEach(0..<10) { _ in
                    DummyNavigationLink {
                        MemberRowLoading()
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
                ForEach(viewModel.items) { constituency in
                    ContextAwareNavigationLink(value: .constituencyDetailView(constituency: constituency)) {
                        ConstituencyRow(consituency: constituency)
                            .onAppear(perform: { onScrollEnd(constituency: constituency )})
                    }
                }
            }
        }
        .listStyle(.grouped)
    }

    private func onScrollEnd(constituency: Constituency) {
        if constituency == viewModel.items.last {
            viewModel.nextData()
        }
    }
}

import SwiftUI

struct ConstituenciesView: View {
    @StateObject var viewModel = ConstituenciesViewModel()

    var resultsText: String {
        "\(viewModel.numResults) results" + (viewModel.search != "" ? " for '\(viewModel.search)'" : "")
    }

    var body: some View {
        Group {
            if viewModel.consituencies.count > 0 {
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
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Enter a name or postcode")
        .onSubmit(of: .search) {
            viewModel.nextData(reset: true)
        }
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(reset: true)
            }
        }
        .navigationTitle("Constituencies")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.consituencies.isEmpty {
                viewModel.nextData(reset: true)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List(0..<10) { _ in
            NavigationLink {
                Text("")
            } label: {
                MemberRowLoading()
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
                ForEach(viewModel.consituencies) { constituency in
                    ContextAwareNavigationLink(value: .constituencyDetailView(constituency: constituency)) {
                        ConstituencyRow(consituency: constituency)
                            .onAppear(perform: { onScrollEnd(constituency: constituency )})
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private func onScrollEnd(constituency: Constituency) {
        if constituency == viewModel.consituencies.last {
            viewModel.nextData()
        }
    }
}

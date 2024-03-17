import SwiftUI

struct UnifiedListView<T, RowContent, LoadingContent>: View where T: Identifiable, T: Equatable, RowContent: View, LoadingContent: View {
    @StateObject var viewModel: UnifiedListViewModel<T>
    var rowView: (T) -> RowContent
    var rowLoadingView: () -> LoadingContent
    var navigationTitle: String
    var searchPrompt: String
    var showNumResults: Bool

    init(
        viewModel: UnifiedListViewModel<T>,
        rowView: @escaping (T) -> RowContent,
        rowLoadingView: @escaping () -> LoadingContent,
        navigationTitle: String,
        searchPrompt: String = "Search",
        showNumResults: Bool = true
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.rowView = rowView
        self.rowLoadingView = rowLoadingView
        self.navigationTitle = navigationTitle
        self.searchPrompt = searchPrompt
        self.showNumResults = showNumResults
    }

    var body: some View {
        Group {
            if viewModel.loading {
                loadingView
                    .opacity(0.5)
            } else if !viewModel.items.isEmpty {
                scrollView
            } else {
                NoDataView()
            }
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: searchPrompt)
        .autocorrectionDisabled(true)
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(reset: true)
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.nextData(reset: true)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                if showNumResults {
                    Text(resultsText)
                        .padding(.leading, 10)
                        .skeleton(with: true)
                }
                ForEach(0..<20) { _ in
                    DummyNavigationLink {
                        rowLoadingView()
                    }
                }
            }
            .padding()
        }
        .environment(\.isScrollEnabled, false)
    }

    private var resultsText: String {
        "\(viewModel.totalResults) results"
    }

    @Environment(\.colorScheme) var colorScheme

    @ViewBuilder
    var scrollView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                if showNumResults {
                    Text(resultsText)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 10)
                        .frame(height: 20)
                }
                ForEach(viewModel.items) { item in
                    rowView(item)
                        .foregroundStyle(.primary)
                        .onAppear(perform: { onScrollEnd(item: item) })
                }
            }
            .padding()
        }
        .appBackground(colorScheme: colorScheme)
    }

    private func onScrollEnd(item: T) {
        if item == viewModel.items.last {
            viewModel.nextData()
        }
    }
}

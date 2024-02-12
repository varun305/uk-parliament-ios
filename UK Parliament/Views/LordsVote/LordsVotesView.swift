import SwiftUI

struct LordsVotesView: View {
    @StateObject var viewModel = LordsVotesViewModel()

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
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a lords vote")
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(reset: true)
            }
        }
        .navigationTitle("Lords votes")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.nextData(reset: true)
            }
        }
        .toolbarBackground(Color.lords.opacity(0.1))
    }

    @ViewBuilder
    var loadingView: some View {
        List(0..<20) { _ in
            DummyNavigationLink {
                CommonsVoteRowLoading()
            }
        }
        .listStyle(.grouped)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        List(viewModel.items) { vote in
            ContextAwareNavigationLink(value: .lordsVoteDetailView(vote: vote)) {
                LordsVoteRow(vote: vote)
                    .onAppear(perform: { onScrollEnd(vote: vote) })
            }
        }
        .listStyle(.grouped)
    }

    private func onScrollEnd(vote: LordsVote) {
        if vote == viewModel.items.last {
            viewModel.nextData()
        }
    }
}

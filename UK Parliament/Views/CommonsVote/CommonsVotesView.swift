import SwiftUI

struct CommonsVotesView: View {
    @StateObject var viewModel = CommonsVotesViewModel()

    var body: some View {
        Group {
            if viewModel.loading && viewModel.votes.isEmpty {
                loadingView
            } else if !viewModel.votes.isEmpty {
                scrollView
            } else {
                NoDataView()
            }
        }
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a commons vote")
        .onChange(of: viewModel.search) { _, new in
            if new.isEmpty {
                viewModel.search = ""
                viewModel.nextData(reset: true)
            }
        }
        .navigationTitle("Commons votes")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.votes.isEmpty {
                viewModel.nextData(reset: true)
            }
        }
        .toolbarBackground(Color.commons.opacity(0.1))
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
        List(viewModel.votes) { vote in
            ContextAwareNavigationLink(value: .commonsVoteDetailView(vote: vote)) {
                CommonsVoteRow(vote: vote)
                    .onAppear(perform: { onScrollEnd(vote: vote) })
            }
        }
        .listStyle(.grouped)
    }

    private func onScrollEnd(vote: CommonsVote) {
        if vote == viewModel.votes.last {
            viewModel.nextData()
        }
    }
}

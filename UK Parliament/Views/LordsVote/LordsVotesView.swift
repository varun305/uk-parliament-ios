import SwiftUI

struct LordsVotesView: View {
    @StateObject var viewModel = LordsVotesViewModel()

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
            if viewModel.votes.isEmpty {
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
        List(viewModel.votes) { vote in
//            ContextAwareNavigationLink() {
                LordsVoteRow(vote: vote)
                    .onAppear(perform: { onScrollEnd(vote: vote) })
//            }
        }
        .listStyle(.grouped)
    }

    private func onScrollEnd(vote: LordsVote) {
        if vote == viewModel.votes.last {
            viewModel.nextData()
        }
    }
}

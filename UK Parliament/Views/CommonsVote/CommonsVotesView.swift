import SwiftUI

struct CommonsVotesView: View {
    @StateObject var viewModel = CommonsVotesViewModel()

    var body: some View {
        Group {
            if viewModel.votes.count > 0 {
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
        .searchable(text: $viewModel.search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a commons vote")
        .onSubmit(of: .search) {
            viewModel.nextData(reset: true)
        }
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
        List(0..<10) { _ in
            NavigationLink {
                Text("")
            } label: {
                CommonsVoteRowLoading()
            }
            .disabled(true)
        }
        .listStyle(.plain)
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
        .listStyle(.plain)
    }

    private func onScrollEnd(vote: CommonsVote) {
        if vote == viewModel.votes.last {
            viewModel.nextData()
        }
    }
}

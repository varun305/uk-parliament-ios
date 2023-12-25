import SwiftUI

struct CommonsVotesView: View {
    @StateObject var viewModel = CommonsVotesViewModel()

    var body: some View {
        List {
            ForEach(viewModel.votes) { vote in
                CommonsVoteRow(vote: vote)
                    .onAppear(perform: { onScrollEnd(vote: vote )})
            }
        }
        .listStyle(.plain)
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
    }

    private func onScrollEnd(vote: CommonsVote) {
        if vote == viewModel.votes.last {
            viewModel.nextData()
        }
    }
}

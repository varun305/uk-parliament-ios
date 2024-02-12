import SwiftUI

struct MemberLordsVotesView: View {
    @StateObject var viewModel: MemberLordsVotesViewModel

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
        .navigationTitle("Lords votes, \(viewModel.member.nameDisplayAs ?? "")")
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
        List(viewModel.items) { memberVote in
            MemberLordsVoteRow(memberVote: memberVote)
                .ifLet(memberVote.publishedDivision) { view, lordsVote in
                    ContextAwareNavigationLink(value: .lordsVoteDetailView(vote: lordsVote)) {
                        view
                    }
                }
                .onAppear(perform: { onScrollEnd(memberVote: memberVote) })
        }
        .listStyle(.grouped)
    }

    private func onScrollEnd(memberVote: MemberLordsVote) {
        if memberVote == viewModel.items.last {
            viewModel.nextData()
        }
    }
}

import SwiftUI

struct CommonsVoteDetailView: View {
    @StateObject var viewModel = CommonsVoteDetailViewModel()
    var vote: CommonsVote

    var body: some View {
        Group {
            if viewModel.vote != nil {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
            }
        }
        .ifLet(vote.title) { $0.navigationTitle("Votes, \($1)") }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let divisionId = vote.divisionId {
                viewModel.fetchData(for: divisionId)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                ForEach(0..<20) { _ in
                    NavigationLink {
                        Text("")
                    } label: {
                        VoterRowLoading()
                    }
                    .disabled(true)
                }
            }
        }
        .listStyle(.grouped)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            if let ayeCount = vote.ayeCount, let noCount = vote.noCount {
                HStack(alignment: .center) {
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.secondary)
                        Text("\(ayeCount)")
                            .font(.title)
                            .if(ayeCount > noCount) { $0.bold() }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text("Ayes \(ayeCount)"))
                    Spacer()
                    HStack {
                        Text("\(noCount)")
                            .font(.title)
                            .if(ayeCount < noCount) { $0.bold() }
                        Image(systemName: "hand.thumbsdown.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text("Noes \(noCount)"))
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.horizontal, 20)
            }

            Section("Votes") {
                VoteChart(yesVotes: viewModel.ayesGrouping, noVotes: viewModel.noesGrouping)
            }
            .accessibilityHidden(true)

            if let vote = viewModel.vote {
                ContextAwareNavigationLink(value: .allVotesView(allVotes: vote)) {
                    Label(
                        title: { Text("View all votes") },
                        icon: {
                            ZStack {
                                Rectangle()
                                    .aspectRatio(1.0, contentMode: .fit)
                                    .foregroundStyle(Color.commons)
                                    .mask {
                                        RoundedRectangle(cornerRadius: 5)
                                    }
                                Image(systemName: "person.3.fill")
                                    .resizable()
                                    .padding(3)
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(.white)
                            }
                        }
                    )
                }
            }
        }
    }
}

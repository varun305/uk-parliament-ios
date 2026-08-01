import SwiftUI
import SkeletonUI

struct CommonsVoteDetailView: View {
    @StateObject var viewModel = CommonsVoteDetailViewModel()
    @Environment(\.requestReview) private var requestReview
    var vote: CommonsVote

    var formattedDate: String {
        vote.date?.convertToDate() ?? ""
    }

    var body: some View {
        Group {
            if viewModel.vote != nil {
                scrollView
            } else if viewModel.loading {
                LoadingView()
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
        .onChange(of: viewModel.vote != nil) { _, loaded in
            guard loaded else { return }
            ReviewManager.shared.recordSuccessMoment()
            ReviewManager.shared.requestReviewIfAppropriate(using: requestReview)
        }
    }

    @ViewBuilder
    var scrollView: some View {
        if let detailedVote = viewModel.vote {
            let ayeCount = detailedVote.ayeCount ?? vote.ayeCount ?? 0
            let noCount = detailedVote.noCount ?? vote.noCount ?? 0

            ScrollView {
                VStack(spacing: 16) {
                    heroCard(vote: detailedVote, ayeCount: ayeCount, noCount: noCount)
                    if !viewModel.ayesGrouping.isEmpty {
                        partySection(title: "Aye votes by party", grouping: viewModel.ayesGrouping, total: ayeCount)
                    }
                    if !viewModel.noesGrouping.isEmpty {
                        partySection(title: "No votes by party", grouping: viewModel.noesGrouping, total: noCount)
                    }
                    viewAllVotesCard(detailedVote: detailedVote)
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

    @ViewBuilder
    func heroCard(vote: CommonsVote, ayeCount: Int, noCount: Int) -> some View {
        MinimalSection(title: "Result") {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        if !formattedDate.isEmpty {
                            Text(formattedDate)
                        }
                        
                        Spacer()
                        if let number = vote.number {
                            Text("Division No. \(number)")
                                .foregroundStyle(.secondary)
                        }
                    }

                    Divider()

                    HStack(alignment: .top) {
                        HStack(spacing: 3) {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundStyle(.secondary)
                            Text(ayeCount.formatted())
                                .font(.title2)
                                .if(ayeCount > noCount) { view in view.fontWeight(.bold) }
                        }
                        Spacer()
                        HStack(spacing: 3) {
                            Text(noCount.formatted())
                                .font(.title2)
                                .if(ayeCount < noCount) { view in view.fontWeight(.bold) }
                            Image(systemName: "hand.thumbsdown.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
            }
        }
    }

    @ViewBuilder
    func statCard(title: String, value: String, color: Color) -> some View {
        GroupedCard {
            VStack(spacing: 6) {
                Text(value)
                    .font(.callout)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .foregroundStyle(color)
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
    }

    @ViewBuilder
    func partySection(title: String, grouping: [(PartyHashable, Int)], total: Int) -> some View {
        MinimalSection(title: title) {
            ForEach(grouping.indices, id: \.self) { index in
                let (party, count) = grouping[index]
                if index > 0 {
                    Divider().padding(.leading, 16)
                }
                partyRow(party: party, count: count, total: total)
            }

            Spacer().frame(height: 6)
        }
    }

    @ViewBuilder
    func partyRow(party: PartyHashable, count: Int, total: Int) -> some View {
        let share: Double = total > 0 ? Double(count) / Double(total) : 0
        let partyColor = Color(hexString: party.partyColour ?? "888888")

        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(partyColor)
                        .frame(width: 10, height: 10)
                        .padding(.top, 3)
                    Text(party.party)
                        .font(.subheadline)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(count.formatted())
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(UIColor.systemFill))
                        .frame(height: 5)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(partyColor)
                        .frame(width: max(geo.size.width * share, share > 0 ? 4 : 0), height: 5)
                }
            }
            .frame(height: 5)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }

    @ViewBuilder
    func viewAllVotesCard(detailedVote: CommonsVote) -> some View {
        GroupedCard {
            ContextAwareNavigationLink(value: .allVotesView(allVotes: detailedVote)) {
                DetailLinkRow(title: "View all votes", image: "vote", color: .commons)
            }
            .foregroundStyle(.primary)
        }
    }
}

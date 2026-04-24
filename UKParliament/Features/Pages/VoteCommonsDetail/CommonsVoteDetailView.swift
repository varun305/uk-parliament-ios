import SwiftUI
import SkeletonUI

struct CommonsVoteDetailView: View {
    @StateObject var viewModel = CommonsVoteDetailViewModel()
    var vote: CommonsVote

    var formattedDate: String {
        vote.date?.convertToDate() ?? ""
    }

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
            Section {
                Text("").skeleton(with: true).frame(height: 10)
                Text("").skeleton(with: true).frame(height: 10)
                Text("").skeleton(with: true).frame(height: 10)
            }
            Section {
                Text("").skeleton(with: true).frame(height: 200)
            }
            Section {
                Text("").skeleton(with: true).frame(height: 10)
                Text("").skeleton(with: true).frame(height: 10)
                Text("").skeleton(with: true).frame(height: 10)
                Text("").skeleton(with: true).frame(height: 10)
            }
        }
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        if let detailedVote = viewModel.vote {
            let ayeCount = detailedVote.ayeCount ?? vote.ayeCount ?? 0
            let noCount = detailedVote.noCount ?? vote.noCount ?? 0
            let majority = abs(ayeCount - noCount)
            let ayesWon = ayeCount >= noCount

            ScrollView {
                VStack(spacing: 16) {
                    heroCard(vote: detailedVote, ayeCount: ayeCount, noCount: noCount, ayesWon: ayesWon)
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
    func heroCard(vote: CommonsVote, ayeCount: Int, noCount: Int, ayesWon: Bool) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(ayesWon ? Color.commons : Color(UIColor.systemRed))
                .frame(height: 5)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        if !formattedDate.isEmpty {
                            Text(formattedDate)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        if let number = vote.number {
                            Text("Division No. \(number)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Text(ayesWon ? "AYES WON" : "NOES WON")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(ayesWon ? Color.commons : Color(UIColor.systemRed))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                Divider()

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Ayes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(ayeCount.formatted())
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(ayesWon ? Color.commons : .primary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text("Noes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(noCount.formatted())
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(!ayesWon ? Color(UIColor.systemRed) : .primary)
                    }
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    func statCard(title: String, value: String, color: Color) -> some View {
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
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    func partySection(title: String, grouping: [(PartyHashable, Int)], total: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, 4)

            ForEach(grouping.indices, id: \.self) { index in
                let (party, count) = grouping[index]
                if index > 0 {
                    Divider().padding(.leading, 16)
                }
                partyRow(party: party, count: count, total: total)
            }

            Spacer().frame(height: 6)
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
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
        ContextAwareNavigationLink(value: .allVotesView(allVotes: detailedVote)) {
            HStack {
                Label("View all votes", image: "vote")
                    .labelStyle(SquircleLabelStyle(color: Color.commons))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
        .foregroundStyle(.primary)
    }
}

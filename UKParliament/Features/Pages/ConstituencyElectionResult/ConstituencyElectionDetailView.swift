import SwiftUI
import Charts
import SkeletonUI

struct ConstituencyElectionDetailView: View {
    @StateObject var viewModel = ConstituencyElectionDetailViewModel()
    var constituency: Constituency
    var electionResult: ElectionResult

    var navTitle: String {
        if let name = constituency.name, electionResult.formattedDate != "" {
            return "\(name) election result, \(electionResult.formattedDate)"
        } else {
            return "Election result"
        }
    }

    var body: some View {
        Group {
            if viewModel.result != nil {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
            }
        }
        .navigationTitle(navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let constituencyId = constituency.id, let electionId = electionResult.id {
                viewModel.fetchData(in: constituencyId, at: electionId)
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
                ZStack {
                    Circle().stroke(.white, lineWidth: 3).skeleton(with: true)
                    Circle().fill(.white).padding(5).skeleton(with: true)
                    Text("2").skeleton(with: true)
                }
                .frame(width: 340, height: 340)
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
        if let result = viewModel.result {
            let sorted = (result.candidates ?? []).sorted { $0.votes ?? 0 > $1.votes ?? 0 }
            let totalVotes = sorted.compactMap(\.votes).reduce(0, +)

            ScrollView {
                VStack(spacing: 16) {
                    heroCard(result: result, winner: sorted.first, totalVotes: totalVotes)
                    statsRow(result: result)
                    chartSection(result: result, sorted: sorted)
                    candidatesSection(sorted: sorted, totalVotes: totalVotes)
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

    @ViewBuilder
    func heroCard(result: ElectionResult, winner: CandidateResultModel?, totalVotes: Int) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(result.winningParty?.bgColor ?? .gray)
                .frame(height: 5)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(result.formattedDate)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if let name = result.constituencyName {
                            Text(name)
                                .font(.headline)
                        }
                    }
                    Spacer()
                    PartyTaggedText(text: result.result?.uppercased() ?? "", party: result.winningParty)
                }

                if let winner {
                    Divider()
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Winner")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(winner.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text(winner.party.flatMap(\.name) ?? "Independent")
                                .font(.subheadline)
                                .foregroundStyle(winner.party?.bgColor ?? .secondary)
                        }
                        Spacer()
                        if let votes = winner.votes {
                            VStack(alignment: .trailing, spacing: 3) {
                                Text("Votes")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(votes.formatted())
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(winner.party?.bgColor ?? .primary)
                                if totalVotes > 0 {
                                    Text(String(format: "%.1f%%", Double(votes) / Double(totalVotes) * 100))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
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
    func statsRow(result: ElectionResult) -> some View {
        let percent: Double? = {
            guard let t = result.turnout, let e = result.electorate, e > 0 else { return nil }
            return Double(t) / Double(e) * 100
        }()

        HStack(spacing: 10) {
            statCard(
                title: "Majority",
                value: (result.majority ?? 0).formatted(),
                color: .primary
            )
            statCard(
                title: "Turnout",
                value: percent.map { String(format: "%.1f%%", $0) } ?? (result.turnout ?? 0).formatted(),
                color: .primary
            )
            statCard(
                title: "Electorate",
                value: (result.electorate ?? 0).formatted(),
                color: .primary
            )
        }
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
    func chartSection(result: ElectionResult, sorted: [CandidateResultModel]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Vote share")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, 8)

            Chart(sorted, id: \.name) { candidate in
                SectorMark(
                    angle: .value("Votes", candidate.votes ?? 0),
                    innerRadius: .ratio(0.65)
                )
                .foregroundStyle(candidate.party?.bgColor ?? .gray)
            }
            .chartLegend(.hidden)
            .chartBackground { proxy in
                GeometryReader { geo in
                    let frame = geo[proxy.plotFrame!]
                    VStack(spacing: 2) {
                        Text(result.result.map { $0.uppercased() } ?? "")
                            .bold()
                            .font(.title2)
                        Text("Majority of \((result.majority ?? 0).formatted())")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
            .frame(height: 280)
            .padding(.horizontal)
            .padding(.bottom, 14)
            .accessibilityHidden(true)
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    func candidatesSection(sorted: [CandidateResultModel], totalVotes: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("All candidates")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, 4)

            ForEach(sorted.indices, id: \.self) { index in
                let candidate = sorted[index]
                if index > 0 {
                    Divider().padding(.leading, 52)
                }
                candidateRow(candidate: candidate, totalVotes: totalVotes, rank: index + 1)
            }

            Spacer().frame(height: 6)
        }
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    @ViewBuilder
    func candidateRow(candidate: CandidateResultModel, totalVotes: Int, rank: Int) -> some View {
        let voteShare: Double = totalVotes > 0 ? Double(candidate.votes ?? 0) / Double(totalVotes) : 0

        HStack(alignment: .top, spacing: 12) {
            Text("\(rank)")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .frame(width: 24, alignment: .trailing)
                .padding(.top, 3)

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(candidate.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(candidate.party.flatMap(\.name) ?? "Independent")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text((candidate.votes ?? 0).formatted())
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        HStack(spacing: 4) {
                            Text(String(format: "%.1f%%", voteShare * 100))
                            if let change = candidate.resultChange, !change.isEmpty {
                                Text("(\(change))")
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(UIColor.systemFill))
                            .frame(height: 5)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(candidate.party?.bgColor ?? .gray)
                            .frame(width: max(geo.size.width * voteShare, voteShare > 0 ? 4 : 0), height: 5)
                    }
                }
                .frame(height: 5)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

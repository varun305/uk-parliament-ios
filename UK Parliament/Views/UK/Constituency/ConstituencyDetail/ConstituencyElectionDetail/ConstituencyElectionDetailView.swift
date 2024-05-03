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
        .onAppear {
            if let constituencyId = constituency.id, let electionId = electionResult.id {
                viewModel.fetchData(in: constituencyId, at: electionId)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section {
                Text("")
                    .skeleton(with: true)
                    .frame(height: 10)
                Text("")
                    .skeleton(with: true)
                    .frame(height: 10)
                Text("")
                    .skeleton(with: true)
                    .frame(height: 10)
            }

            Section {
                ZStack {
                    Circle()
                        .stroke(.white, lineWidth: 3)
                        .skeleton(with: true)
                    Circle()
                        .fill(.white)
                        .padding(5)
                        .skeleton(with: true)
                    Text("2")
                        .skeleton(with: true)
                }
                .frame(width: 340, height: 340)
            }

            Section {
                Text("")
                    .skeleton(with: true)
                    .frame(height: 10)
                Text("")
                    .skeleton(with: true)
                    .frame(height: 10)
                Text("")
                    .skeleton(with: true)
                    .frame(height: 10)
                Text("")
                    .skeleton(with: true)
                    .frame(height: 10)
            }
        }
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        if let result = viewModel.result {
            List {
                Section("\(result.constituencyName ?? ""), \(result.formattedDate)") {
                    HStack {
                        PartyTaggedText(text: result.result?.uppercased() ?? "", party: result.winningParty)

                        Spacer()
                        Text(result.formattedDate)
                            .bold()
                    }
                    HStack {
                        Text("Majority")
                        Spacer()
                        Text(String(result.majority ?? 0))
                            .bold()
                    }
                    HStack {
                        Text("Turnout")
                        Spacer()
                        Text(String(result.turnout ?? 0))
                            .bold()
                    }
                    HStack {
                        Text("Electorate")
                        Spacer()
                        Text(String(result.electorate ?? 0))
                            .bold()
                    }
                }

                Section("Vote share") {
                    pieView
                        .frame(height: 350)
                        .padding(3)
                }
                .accessibilityHidden(true)

                Section("All votes") {
                    barView
                        .frame(height: 300 * CGFloat((result.candidates ?? []).count) / 6)
                        .padding(3)
                }
            }
        }
    }

    @ViewBuilder
    var pieView: some View {
        if let result = viewModel.result {
            Chart((result.candidates ?? []).sorted { $0.votes ?? 0 > $1.votes ?? 0 }, id: \.name) { candidate in
                SectorMark(
                    angle: .value("Votes", candidate.votes ?? 0),
                    innerRadius: .ratio(0.65)
                )
                .foregroundStyle(candidate.party?.bgColor ?? .white)
            }
            .chartLegend(.hidden)
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    VStack {
                        Text(result.result?.uppercased() ?? "")
                            .bold()
                            .font(.title2)
                        Text("Majority of \(result.majority ?? 0)")
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
    }

    @ViewBuilder
    var barView: some View {
        if let result = viewModel.result {
            Chart((result.candidates ?? []).sorted { $0.votes ?? 0 > $1.votes ?? 0 }, id: \.name) { candidate in
                BarMark(
                    x: .value("Votes", candidate.votes ?? 0),
                    y: .value("Candidate", "\(candidate.name), \(candidate.party?.name ?? "")")
                )
                .annotation(position: .trailing) {
                    Text(getBarAnnotation(for: candidate))
                        .font(.caption)
                }
                .foregroundStyle(candidate.party?.bgColor ?? .black)
            }
            .chartXAxis(.hidden)
        }
    }

    private func getBarAnnotation(for candidate: CandidateResultModel) -> String {
        if let votes = candidate.votes, let resultChange = candidate.resultChange, resultChange != "" {
            return "\(votes) (\(resultChange))"
        } else if let votes = candidate.votes {
            return String(votes)
        } else {
            return ""
        }
    }
}

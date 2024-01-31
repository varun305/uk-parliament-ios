import SwiftUI
import Charts

struct ConstituencyElectionDetailView: View {
    @StateObject var viewModel = ConstituencyElectionDetailViewModel()
    var constituency: Constituency
    var electionResult: ElectionResult

    var body: some View {
        Group {
            if let result = viewModel.result {
                List {
                    Section("\(result.constituencyName), \(result.electionDate.convertToDate())") {
                        HStack {
                            PartyTaggedText(text: result.result.uppercased(), party: result.winningParty)

                            Spacer()
                            Text(result.electionDate.convertToDate())
                                .bold()
                        }
                        HStack {
                            Text("Majority")
                            Spacer()
                            Text(String(result.majority))
                                .bold()
                        }
                        HStack {
                            Text("Electorate")
                            Spacer()
                            Text(String(result.electorate))
                                .bold()
                        }
                    }

                    Section("Vote share") {
                        pieView
                            .frame(height: 350)
                            .padding(3)
                    }

                    Section("All votes") {
                        barView
                            .frame(height: 300 * CGFloat(result.candidates.count) / 6)
                            .padding(3)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Election results")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let constituencyId = constituency.id {
                viewModel.fetchData(in: constituencyId, at: electionResult)
            }
        }
    }

    @ViewBuilder
    var pieView: some View {
        if let result = viewModel.result {
            Chart(result.candidates.sorted { $0.votes > $1.votes }, id: \.name) { candidate in
                SectorMark(
                    angle: .value("Votes", candidate.votes),
                    innerRadius: .ratio(0.65)
                )
                .foregroundStyle(candidate.party.bgColor)
            }
            .chartLegend(.hidden)
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    VStack {
                        Text(result.result.uppercased())
                            .bold()
                            .font(.title2)
                        Text("Majority of \(result.majority)")
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
    }

    @ViewBuilder
    var barView: some View {
        if let result = viewModel.result {
            Chart(result.candidates.sorted { $0.votes > $1.votes }, id: \.name) { candidate in
                BarMark(
                    x: .value("Votes", candidate.votes),
                    y: .value("Candidate", "\(candidate.name), \(candidate.party.abbreviation?.uppercased() ?? candidate.party.name ?? "")")
                )
                .annotation(position: .trailing) {
                    Text(String(candidate.votes))
                        .font(.caption)
                }
                .foregroundStyle(candidate.party.bgColor)
            }
            .chartXAxis(.hidden)
        }
    }
}

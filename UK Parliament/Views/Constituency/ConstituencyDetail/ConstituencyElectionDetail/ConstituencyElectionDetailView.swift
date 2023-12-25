import SwiftUI

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

                    Section("Candidates") {
                        ForEach(result.candidates.sorted { $0.votes > $1.votes }, id: \.name) { candidate in
                            HStack {
                                Text((candidate.party.abbreviation ?? candidate.party.name).uppercased())
                                    .bold()
                                    .foregroundStyle(Color(hexString: candidate.party.foregroundColour ?? "000000"))
                                    .padding(4)
                                    .background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundStyle(Color(hexString: candidate.party.backgroundColour ?? "ffffff"))
                                    }
                                Text(candidate.name)
                                Spacer()
                                Text(String(candidate.votes))
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Election results")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchData(in: constituency.id, at: electionResult)
        }
    }
}

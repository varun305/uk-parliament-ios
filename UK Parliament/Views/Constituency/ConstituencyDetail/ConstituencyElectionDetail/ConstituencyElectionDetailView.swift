import SwiftUI

struct ConstituencyElectionDetailView: View {
    @StateObject var viewModel = ConstituencyElectionDetailViewModel()
    var constituencyId: Int
    var electionResult: ElectionResult

    var body: some View {
        Group {
            if let result = viewModel.result {
                List {
                    Section("\(result.constituencyName), \(convertDate(from: result.electionDate))") {
                        HStack {
                            PartyTaggedText(text: result.result.uppercased(), party: result.winningParty)

                            Spacer()
                            Text(convertDate(from: result.electionDate))
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
            viewModel.fetchData(in: constituencyId, at: electionResult)
        }
    }

    private func convertDate(from date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: date)?.formatted(date: .abbreviated, time: .omitted) ?? ""
    }
}

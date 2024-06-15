import SwiftUI
import Charts

struct VoteChart: View {

    var yesVotes: [(PartyHashable, Int)]
    var noVotes: [(PartyHashable, Int)]

    init(yesVotes: [(PartyHashable, Int)], noVotes: [(PartyHashable, Int)]) {
        self.yesVotes = yesVotes
        self.noVotes = noVotes
    }

    var body: some View {
        Chart {
            ForEach(yesVotes, id: \.0) { party, number in
                BarMark(
                    x: .value("Ayes", "Ayes"),
                    y: .value("Votes", number)
                )
                .foregroundStyle(by: .value("Party", "\(party.party), \(number)"))
            }
            ForEach(noVotes, id: \.0) { party, number in
                BarMark(
                    x: .value("Noes", "Noes"),
                    y: .value("Votes", number)
                )
                .foregroundStyle(by: .value("Party", "\(party.party), \(number)"))
            }
        }
        .chartForegroundStyleScale(range: graphColours())
        .chartLegend(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 300)

        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                ForEach(yesVotes, id: \.0) { party, number in
                    legendRow(party, number)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                ForEach(noVotes, id: \.0) { party, number in
                    legendRowRight(party, number)
                }
            }
        }
    }

    @ViewBuilder
    private func legendRow(_ party: PartyHashable, _ number: Int) -> some View {
        HStack {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundStyle(Color(hexString: party.partyColour ?? "0000000"))
            Text("\(party.party), \(number)")
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
        }
        .foregroundStyle(.primary)
        .font(.footnote)
    }

    @ViewBuilder
    private func legendRowRight(_ party: PartyHashable, _ number: Int) -> some View {
        HStack {
            Text("\(party.party), \(number)")
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.primary)
            Circle()
                .frame(width: 10, height: 10)
                .foregroundStyle(Color(hexString: party.partyColour ?? "0000000"))
        }
        .font(.footnote)
    }

    private func graphColours() -> [Color] {
        yesVotes.map {
            Color(hexString: $0.0.partyColour ?? "000000")
        } + noVotes.map {
            Color(hexString: $0.0.partyColour ?? "000000")
        }
    }
}

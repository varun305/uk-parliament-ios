import SwiftUI

struct ConstituencyRow: View {
    var consituency: Constituency
    var party: PartyModel {
        consituency.member.latestParty
    }

    var body: some View {
        HStack(alignment: .center) {
            PartyCircleView(party: party)

            VStack(alignment: .leading) {
                Text(consituency.name)
                    .bold()
                Text(consituency.member.nameDisplayAs)
            }
        }
    }
}

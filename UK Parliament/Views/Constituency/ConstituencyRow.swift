import SwiftUI

struct ConstituencyRow: View {
    var consituency: Constituency
    var party: PartyModel {
        consituency.member.latestParty
    }

    var body: some View {
        HStack(alignment: .center) {
            MemberPictureView(member: consituency.member)
                .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text(consituency.name)
                    .bold()
                Text(consituency.member.nameDisplayAs)
                    .font(.footnote)
                Text(party.name)
                    .font(.caption)
            }
        }
    }
}

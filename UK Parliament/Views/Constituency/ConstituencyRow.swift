import SwiftUI

struct ConstituencyRow: View {
    var consituency: Constituency
    var party: PartyModel? {
        consituency.member?.latestParty
    }

    var body: some View {
        HStack(alignment: .center) {
            if let member = consituency.member {
                MemberPictureView(member: member)
                    .frame(width: 60, height: 60)
            }

            VStack(alignment: .leading) {
                Text(consituency.name)
                    .bold()
                if let member = consituency.member {
                    Text(member.nameDisplayAs)
                        .font(.footnote)
                }
                if let party = party {
                    Text(party.name)
                        .font(.caption)
                }
            }

            Spacer()
        }
    }
}

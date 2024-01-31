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
                Text(consituency.name ?? "")
                    .multilineTextAlignment(.leading)
                    .bold()
                if let member = consituency.member {
                    Text(member.nameDisplayAs)
                        .font(.footnote)
                }
                if let name = party?.name {
                    Text(name)
                        .font(.caption)
                }
            }

            Spacer()
        }
    }
}

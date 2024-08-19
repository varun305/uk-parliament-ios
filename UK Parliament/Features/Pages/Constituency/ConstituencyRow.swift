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
                caption
            }

            Spacer()
        }
    }
    
    @ViewBuilder
    var caption: some View {
        let memberName = consituency.member?.nameDisplayAs ?? ""
        let partyName = party?.name ?? ""
        Text(memberName + " • " + partyName)
            .accessibilityLabel(Text(memberName + ", " + partyName))
            .foregroundStyle(.secondary)
            .font(.footnote)
    }
}

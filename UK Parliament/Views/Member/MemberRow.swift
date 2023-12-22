import SwiftUI

struct MemberRow: View {
    var member: Member

    var body: some View {
        HStack(alignment: .center) {
            MemberPictureView(member: member)
                .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text(member.nameDisplayAs)
                    .bold()
                Text(member.latestParty.name)
                    .font(.footnote)
                Text(member.latestHouseMembership.membershipFrom)
                    .font(.caption)
            }
        }
    }
}

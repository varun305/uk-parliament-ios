import SwiftUI

struct MemberRow: View {
    var member: Member

    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(
                url: URL(string: member.thumbnailUrl)!,
                content: { image in
                    image
                        .resizable()
                },
                placeholder: {
                    Color.secondary
                }
            )
            .mask {
                Circle()
            }
            .overlay {
                Circle()
                    .stroke(Color(hexString: member.latestParty.backgroundColour ?? "ffffff"), lineWidth: 3)
            }
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

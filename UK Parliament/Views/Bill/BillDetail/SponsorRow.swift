import SwiftUI

struct SponsorRow: View {
    var sponsor: Sponsor

    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: sponsor.member.memberPhoto)!,
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
                    .stroke(Color(hexString: sponsor.member.partyColour), lineWidth: 3)
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text(sponsor.member.name)
                    .bold()
                if let organisation = sponsor.organisation {
                    Text(organisation.name)
                        .font(.footnote)
                }
            }
        }
    }
}

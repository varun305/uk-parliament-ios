import SwiftUI

struct MemberPictureView: View {
    var member: Member

    var body: some View {
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
    }
}

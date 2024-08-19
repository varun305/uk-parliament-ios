import SwiftUI

struct MemberPictureView: View {
    var member: Member

    var body: some View {
        if let url = URL(string: member.thumbnailUrl ?? "") {
            AsyncImage(
                url: url,
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
                    .stroke(Color(hexString: member.latestParty?.backgroundColour ?? "ffffff"), lineWidth: 3)
            }
        } else {
            EmptyView()
        }
    }
}

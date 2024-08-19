import SwiftUI

struct SponsorRow: View {
    var sponsor: Sponsor

    var body: some View {
        HStack {
            if let url = URL(string: sponsor.member?.memberPhoto ?? "") {
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
                        .stroke(Color(hexString: sponsor.member?.partyColour ?? "ffffff"), lineWidth: 3)
                }
                .frame(width: 60, height: 60)
            }

            VStack(alignment: .leading) {
                Text(sponsor.member?.name ?? "")
                    .bold()
                if let organisation = sponsor.organisation {
                    Text("On behalf of \(organisation.name ?? "")")
                        .font(.footnote)
                }
            }
        }
    }
}

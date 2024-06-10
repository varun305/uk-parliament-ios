import SwiftUI

struct BannerView: View {
    var banner: Banner

    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .mask {
                    RoundedRectangle(cornerRadius: 10)
                }
            content
        }
    }

    @ViewBuilder
    var content: some View {
        HStack(alignment: .center, spacing: 10) {
            if let image = banner.image {
                image
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.accent)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(banner.title)
                    .bold()
                if let subtitle = banner.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .padding(10)
    }
}

#Preview {
    BannerView(banner: Banner(
        title: "We have an election!",
        subtitle: "There won't be any MPs until after the result",
        image: Image("info")
    ))
}

import SwiftUI

struct GridItemView: View {
    @EnvironmentObject var contextModel: ContextModel

    var title: String
    var subtitle: String
    var systemImage: Image
    var background: Color
    var foreground: Color
    var navigateTo: NavigationItem

    init(
        title: String,
        subtitle: String,
        systemImage: String,
        background: Color,
        foreground: Color,
        navigateTo: NavigationItem
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = Image(systemName: systemImage)
        self.background = background
        self.foreground = foreground
        self.navigateTo = navigateTo
    }

    var body: some View {
        Button {
            contextModel.manualNavigate(to: navigateTo)
        } label: {
            face
                .accessibilityElement(children: .combine)
        }
        .foregroundStyle(.primary)
    }

    @ViewBuilder
    var face: some View {
        ZStack {
            background
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .bold()
                    Text(subtitle)
                        .font(.caption)
                }
                .foregroundStyle(foreground)
                .multilineTextAlignment(.leading)
                Spacer(minLength: 40)
                systemImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 60, maxHeight: 60)
                    .foregroundStyle(foreground)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 30)
        }
        .frame(minHeight: 120)
        .mask {
            RoundedRectangle(cornerRadius: 20)
        }
        .shadow(radius: 2)
    }
}

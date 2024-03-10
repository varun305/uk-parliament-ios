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
        }
        .foregroundStyle(.primary)
    }

    @ViewBuilder
    var face: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack {
                background
                VStack(alignment: .center, spacing: 10) {
                    systemImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 60, maxHeight: 60)
                        .foregroundStyle(foreground)
                    Text(title)
                        .font(.headline)
                        .bold()
                        .foregroundStyle(foreground)
                }
                .padding(.horizontal, 2)
            }
            .frame(width: 160, height: 160)
            .mask {
                RoundedRectangle(cornerRadius: 20)
            }
            .shadow(radius: 2)
            Text(subtitle)
                .font(.caption)
        }
        .frame(maxWidth: 160)
    }
}

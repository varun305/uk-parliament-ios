import SwiftUI

struct LargePageItemView: View {
    @EnvironmentObject var contextModel: ContextModel

    var gridItem: PageItem

    init(gridItem: PageItem) {
        self.gridItem = gridItem
    }

    var body: some View {
        ContextAwareNavigationLink(value: gridItem.navigateTo) {
            HStack(spacing: 14) {
                // Icon badge
                Image(gridItem.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26, height: 26)
                    .foregroundStyle(gridItem.background)
                    .padding(10)
                    .background(.white.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityHidden(true)

                // Text
                VStack(alignment: .leading, spacing: 2) {
                    Text(gridItem.title)
                        .font(.headline)
                    Text(gridItem.subtitle)
                        .font(.caption)
                        .opacity(0.85)
                }
                .foregroundStyle(gridItem.foreground)
                .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(gridItem.foreground.opacity(0.7))
                    .accessibilityHidden(true)
            }
            .padding(16)
            .background(gridItem.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: gridItem.background.opacity(0.3), radius: 4, y: 2)
            .accessibilityElement(children: .combine)
        }
        .foregroundStyle(.primary)
    }
}

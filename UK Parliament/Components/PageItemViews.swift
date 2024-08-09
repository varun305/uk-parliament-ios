import SwiftUI

struct LargePageItemView: View {
    @EnvironmentObject var contextModel: ContextModel

    var gridItem: PageItem

    init(
        gridItem: PageItem
    ) {
        self.gridItem = gridItem
    }

    var body: some View {
        ContextAwareNavigationLink(value: gridItem.navigateTo, addChevron: false) {
            face
                .accessibilityElement(children: .combine)
        }
        .foregroundStyle(.primary)
    }

    @ViewBuilder
    var face: some View {
        ZStack {
            gridItem.background
            HStack(alignment: .center, spacing: 15) {
                Image(gridItem.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 45, maxHeight: 45)
                    .foregroundStyle(gridItem.foreground)
                    .accessibilityHidden(true)
                VStack(alignment: .leading) {
                    Text(gridItem.title)
                        .font(.headline)
                        .bold()
                    Text(gridItem.subtitle)
                        .font(.caption)
                }
                .foregroundStyle(gridItem.foreground)
                .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "chevron.right")
                    .bold()
                    .foregroundStyle(gridItem.foreground)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 20)
        }
        .frame(minHeight: 80)
        .mask {
            RoundedRectangle(cornerRadius: 20)
        }
        .shadow(radius: 2)
    }
}

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
        ContextAwareNavigationLink(value: gridItem.navigateTo) {
            face
                .accessibilityElement(children: .combine)
        }
        .foregroundStyle(.primary)
    }

    @ViewBuilder
    var face: some View {
        ZStack {
            gridItem.background
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(gridItem.title)
                        .font(.headline)
                        .bold()
                    Text(gridItem.subtitle)
                        .font(.caption)
                }
                .foregroundStyle(gridItem.foreground)
                .multilineTextAlignment(.leading)
                Spacer(minLength: 40)
                HStack(alignment: .center, spacing: 20) {
                    Image(systemName: gridItem.systemImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 60, maxHeight: 60)
                    Image(systemName: "chevron.right")
                        .bold()
                }
                .foregroundStyle(gridItem.foreground)
                .accessibilityHidden(true)
            }
            .padding(.horizontal, 30)
        }
        .frame(minHeight: 100)
        .mask {
            RoundedRectangle(cornerRadius: 20)
        }
        .shadow(radius: 2)
    }
}

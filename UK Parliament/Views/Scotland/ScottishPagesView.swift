import SwiftUI

struct ScottishPagesView: View {
    @EnvironmentObject var contextModel: ContextModel

    let columns = [
        GridItem(.adaptive(minimum: 175))
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 25) {
            membersViewItem
        }
    }

    @ViewBuilder
    var membersViewItem: some View {
        GridItemView(
            title: "MSPs",
            subtitle: "View and search for members of the Scottish Parliament",
            systemImage: "person.3.fill",
            background: .accent,
            foreground: .white,
            navigateTo: .mspsView
        )
    }
}

#Preview {
    ScottishPagesView()
}

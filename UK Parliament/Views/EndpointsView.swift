import SwiftUI

struct EndpointsView: View {
    @EnvironmentObject var contextModel: ContextModel

    let columns = [
        GridItem(.adaptive(minimum: 175))
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 25) {
            billsViewItem
            constituenciesViewItem
            commonsVotesViewItem
            mpsViewItem
            lordsVotesViewItem
            lordsViewItem
            postsViewItem
            partiesViewItem
        }
    }

    @ViewBuilder
    var billsViewItem: some View {
        GridItemView(
            title: "Bills",
            subtitle: "View bills, stages and publications",
            systemImage: "doc.on.doc.fill",
            background: .accent,
            foreground: .white,
            navigateTo: .billsView(member: nil)
        )
    }

    @ViewBuilder
    var constituenciesViewItem: some View {
        GridItemView(
            title: "Constituencies",
            subtitle: "View and search for constituencies",
            systemImage: "map.fill",
            background: .accent,
            foreground: .white,
            navigateTo: .constituenciesView
        )
    }

    @ViewBuilder
    var commonsVotesViewItem: some View {
        GridItemView(
            title: "Commons votes",
            subtitle: "View and filter the results of votes in the House of Commons",
            systemImage: "building.columns.fill",
            background: .commons,
            foreground: .white,
            navigateTo: .commonsVotesView
        )
    }

    @ViewBuilder
    var mpsViewItem: some View {
        GridItemView(
            title: "MPs",
            subtitle: "View and search for members of the House of Commons",
            systemImage: "person.3.fill",
            background: .commons,
            foreground: .white,
            navigateTo: .mpsView
        )
    }

    @ViewBuilder
    var lordsVotesViewItem: some View {
        GridItemView(
            title: "Lords votes",
            subtitle: "View and filter the results of votes in the House of Lords",
            systemImage: "building.columns.fill",
            background: .lords,
            foreground: .white,
            navigateTo: .lordsVotesView
        )
    }

    @ViewBuilder
    var lordsViewItem: some View {
        GridItemView(
            title: "Lords",
            subtitle: "View and search for members of the House of Lords",
            systemImage: "person.3.fill",
            background: .lords,
            foreground: .white,
            navigateTo: .lordsView
        )
    }

    @ViewBuilder
    var postsViewItem: some View {
        GridItemView(
            title: "Posts",
            subtitle: "View government and opposition posts",
            systemImage: "briefcase.fill",
            background: .accent,
            foreground: .white,
            navigateTo: .postsView
        )
    }

    @ViewBuilder
    var partiesViewItem: some View {
        GridItemView(
            title: "Parties",
            subtitle: "View the state of the parties in the Commons and the Lords",
            systemImage: "chart.pie.fill",
            background: .accent,
            foreground: .white,
            navigateTo: .partiesView
        )
    }
}

private struct GridItemView: View {
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

#Preview {
    NavigationStack {
        ScrollView {
            EndpointsView()
                .padding()
        }
        .navigationTitle("Home")
    }
}

import SwiftUI

struct UKPagesView: View {
    @EnvironmentObject var contextModel: ContextModel
    
    var body: some View {
        LazyVStack(spacing: 25) {
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

#Preview {
    NavigationStack {
        ScrollView {
            UKPagesView()
                .padding()
        }
        .navigationTitle("Home")
    }
}

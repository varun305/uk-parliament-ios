import SwiftUI

struct UKPagesView: View {
    @EnvironmentObject var contextModel: ContextModel
    @Binding var search: String

    let gridItems = [
        PageItem(
            title: "Bills",
            subtitle: "View bills, stages and publications",
            image: "bill",
            background: .accent,
            foreground: .white,
            navigateTo: .billsView(member: nil)
        ),
        PageItem(
            title: "Constituencies",
            subtitle: "View and search for constituencies",
            image: "map",
            background: .accent,
            foreground: .white,
            navigateTo: .constituenciesView
        ),
        PageItem(
            title: "Commons votes",
            subtitle: "View and filter the results of votes in the House of Commons",
            image: "vote",
            background: .commons,
            foreground: .white,
            navigateTo: .commonsVotesView
        ),
        PageItem(
            title: "MPs",
            subtitle: "View and search for members of the House of Commons",
            image: "group",
            background: .commons,
            foreground: .white,
            navigateTo: .mpsView
        ),
        PageItem(
            title: "Lords votes",
            subtitle: "View and filter the results of votes in the House of Lords",
            image: "vote",
            background: .lords,
            foreground: .white,
            navigateTo: .lordsVotesView
        ),
        PageItem(
            title: "Lords",
            subtitle: "View and search for members of the House of Lords",
            image: "group",
            background: .lords,
            foreground: .white,
            navigateTo: .lordsView
        ),
        PageItem(
            title: "Posts",
            subtitle: "View government and opposition posts",
            image: "post",
            background: .accent,
            foreground: .white,
            navigateTo: .postsView
        ),
        PageItem(
            title: "Parties",
            subtitle: "View the state of the parties in the Commons and the Lords",
            image: "pie",
            background: .accent,
            foreground: .white,
            navigateTo: .partiesView
        )
    ]

    var filteredGridItems: [PageItem] {
        gridItems.filter {
            $0.title.lowercased().contains(search.lowercased()) ||
            $0.subtitle.lowercased().contains(search.lowercased()) ||
            search.isEmpty
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            ForEach(filteredGridItems) { gridItem in
                LargePageItemView(gridItem: gridItem)
            }
        }
    }
}

struct PageItem: Identifiable {
    var title: String
    var subtitle: String
    var image: String
    var background: Color
    var foreground: Color
    var navigateTo: NavigationItem

    init(title: String, subtitle: String, image: String, background: Color, foreground: Color, navigateTo: NavigationItem) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.background = background
        self.foreground = foreground
        self.navigateTo = navigateTo
    }

    var id: String {
        title + subtitle
    }
}

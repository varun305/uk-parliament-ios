import SwiftUI

struct UKPagesView: View {
    @EnvironmentObject var contextModel: ContextModel

    // MARK: - Page Items

    private let commonsItems = [
        PageItem(
            title: "MPs",
            subtitle: "Members of the House of Commons",
            image: "group",
            systemImage: "person.2.fill",
            background: .commons,
            foreground: .white,
            navigateTo: .mpsView
        ),
        PageItem(
            title: "Commons votes",
            subtitle: "Vote results in the Commons",
            image: "vote",
            systemImage: "checkmark.circle.fill",
            background: .commons,
            foreground: .white,
            navigateTo: .commonsVotesView
        )
    ]

    private let lordsItems = [
        PageItem(
            title: "Lords",
            subtitle: "Members of the House of Lords",
            image: "group",
            systemImage: "person.2.fill",
            background: .lords,
            foreground: .white,
            navigateTo: .lordsView
        ),
        PageItem(
            title: "Lords votes",
            subtitle: "Vote results in the Lords",
            image: "vote",
            systemImage: "checkmark.circle.fill",
            background: .lords,
            foreground: .white,
            navigateTo: .lordsVotesView
        )
    ]

    private let legislationItems = [
        PageItem(
            title: "Bills",
            subtitle: "View bills, stages and publications",
            image: "bill",
            systemImage: "doc.text.fill",
            background: .accent,
            foreground: .white,
            navigateTo: .billsView(member: nil)
        )
    ]

    private let exploreItems = [
        PageItem(
            title: "Constituencies",
            subtitle: "Search by postcode or name",
            image: "map",
            systemImage: "map.fill",
            background: .accent,
            foreground: .white,
            navigateTo: .constituenciesView
        ),
        PageItem(
            title: "Posts",
            subtitle: "Government & opposition posts",
            image: "post",
            systemImage: "briefcase.fill",
            background: .accent,
            foreground: .white,
            navigateTo: .postsView
        ),
        PageItem(
            title: "Parties",
            subtitle: "State of the parties",
            image: "pie",
            systemImage: "chart.pie.fill",
            background: .accent,
            foreground: .white,
            navigateTo: .partiesView
        )
    ]

    private var allItems: [PageItem] {
        commonsItems + lordsItems + legislationItems + exploreItems
    }

    // MARK: - Body

    var body: some View {
        sectionsView
    }


    // MARK: - Sections

    @ViewBuilder
    private var sectionsView: some View {
        VStack(alignment: .leading, spacing: 32) {
            MinimalSection(title: "House of Commons") {
                ForEach(Array(commonsItems.enumerated()), id: \.element.id) { index, item in
                    MinimalRowItem(item: item)
                    if index < commonsItems.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }

            MinimalSection(title: "House of Lords") {
                ForEach(Array(lordsItems.enumerated()), id: \.element.id) { index, item in
                    MinimalRowItem(item: item)
                    if index < lordsItems.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }

            MinimalSection(title: "Legislation") {
                ForEach(Array(legislationItems.enumerated()), id: \.element.id) { index, item in
                    MinimalRowItem(item: item)
                    if index < legislationItems.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }

            MinimalSection(title: "Explore") {
                ForEach(Array(exploreItems.enumerated()), id: \.element.id) { index, item in
                    MinimalRowItem(item: item)
                    if index < exploreItems.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }
        }
    }
}

// MARK: - Page Item Model

struct PageItem: Identifiable {
    var title: String
    var subtitle: String
    var image: String
    var systemImage: String
    var background: Color
    var foreground: Color
    var navigateTo: NavigationItem

    init(title: String, subtitle: String, image: String, systemImage: String = "", background: Color, foreground: Color, navigateTo: NavigationItem) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.systemImage = systemImage
        self.background = background
        self.foreground = foreground
        self.navigateTo = navigateTo
    }

    var id: String {
        title + subtitle
    }
}

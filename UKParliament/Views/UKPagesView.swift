import SwiftUI

struct UKPagesView: View {
    @EnvironmentObject var contextModel: ContextModel
    @Binding var search: String

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

    private var filteredItems: [PageItem] {
        guard !search.isEmpty else { return [] }
        return allItems.filter {
            $0.title.localizedCaseInsensitiveContains(search) ||
            $0.subtitle.localizedCaseInsensitiveContains(search)
        }
    }

    private var isSearching: Bool {
        !search.isEmpty
    }

    // MARK: - Body

    var body: some View {
        if isSearching {
            searchResults
        } else {
            sectionsView
        }
    }

    // MARK: - Search Results

    @ViewBuilder
    private var searchResults: some View {
        if filteredItems.isEmpty {
            ContentUnavailableView.search(text: search)
        } else {
            VStack(spacing: 10) {
                ForEach(filteredItems) { item in
                    LargePageItemView(gridItem: item)
                }
            }
        }
    }

    // MARK: - Sections

    @ViewBuilder
    private var sectionsView: some View {
        VStack(alignment: .leading, spacing: 28) {
            // House of Commons
            HomeSection(title: "House of Commons", systemImage: "building.columns.fill", tint: .commons) {
                HStack(spacing: 12) {
                    ForEach(commonsItems) { item in
                        CompactPageItemView(item: item)
                    }
                }
            }

            // House of Lords
            HomeSection(title: "House of Lords", systemImage: "building.columns.fill", tint: .lords) {
                HStack(spacing: 12) {
                    ForEach(lordsItems) { item in
                        CompactPageItemView(item: item)
                    }
                }
            }

            // Legislation
            HomeSection(title: "Legislation", systemImage: "doc.text.fill", tint: .accentColor) {
                ForEach(legislationItems) { item in
                    LargePageItemView(gridItem: item)
                }
            }

            // Explore
            HomeSection(title: "Explore", systemImage: "safari.fill", tint: .accentColor) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(exploreItems) { item in
                        CompactPageItemView(item: item)
                    }
                }
            }
        }
    }
}

// MARK: - Section Header

private struct HomeSection<Content: View>: View {
    let title: String
    let systemImage: String
    let tint: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)

            content
        }
    }
}

// MARK: - Compact Card for Grid

struct CompactPageItemView: View {
    @EnvironmentObject var contextModel: ContextModel
    let item: PageItem

    var body: some View {
        ContextAwareNavigationLink(value: item.navigateTo) {
            VStack(alignment: .leading, spacing: 12) {
                // Icon badge
                Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
                    .foregroundStyle(item.background)
                    .padding(8)
                    .background(.white.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .accessibilityHidden(true)

                Spacer(minLength: 0)

                // Text
                VStack(alignment: .leading, spacing: 3) {
                    Text(item.title)
                        .font(.subheadline.weight(.bold))
                    Text(item.subtitle)
                        .font(.caption)
                        .opacity(0.85)
                        .lineLimit(2)
                }
                .foregroundStyle(item.foreground)
                .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(14)
            .background(item.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: item.background.opacity(0.3), radius: 4, y: 2)
            .accessibilityElement(children: .combine)
        }
        .foregroundStyle(.primary)
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


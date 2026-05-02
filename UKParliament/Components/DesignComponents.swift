import SwiftUI

// MARK: - Grouped Card Container

/// Wraps content in the standard card style: secondary grouped background, 12pt corner radius, horizontal padding.
struct GroupedCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
    }
}

// MARK: - Card Section Header

/// A title header for use inside a GroupedCard, with an optional separator divider below.
struct CardSectionHeader: View {
    let title: String
    var showDivider: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, showDivider ? 8 : 4)
            if showDivider {
                Divider()
            }
        }
    }
}

// MARK: - Detail Link Row

/// A standard navigation row: squircle icon on the left, title in the middle, chevron on the right.
/// Wrap in ContextAwareNavigationLink to make it tappable.
struct DetailLinkRow: View {
    let title: String
    let image: String
    var isSystemImage: Bool = false
    let color: Color

    var body: some View {
        HStack {
            Group {
                if isSystemImage {
                    Label(title, systemImage: image)
                } else {
                    Label(title, image: image)
                }
            }
            .labelStyle(SquircleLabelStyle(color: color))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

// MARK: - Detail Value Row

/// A key-value detail row: secondary label on the left, custom content on the right.
/// Wrap in ContextAwareNavigationLink for navigable rows (include a chevron in the value content).
struct DetailValueRow<Value: View>: View {
    let label: String
    @ViewBuilder let value: Value

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            value
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

// MARK: - Minimal Section

/// A list-style section with an uppercase footnote header and a rounded card background.
struct MinimalSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                content
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }
}

// MARK: - Minimal Row Item

/// A navigation list row with a tinted icon badge, title, subtitle, and trailing chevron.
struct MinimalRowItem: View {
    let item: PageItem

    var body: some View {
        ContextAwareNavigationLink(value: item.navigateTo) {
            HStack(spacing: 14) {
                Image(systemName: item.systemImage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(item.background)
                    .frame(width: 32, height: 32)
                    .background(item.background.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.body)
                        .foregroundStyle(.primary)
                    Text(item.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .foregroundStyle(.primary)
        .accessibilityElement(children: .combine)
    }
}

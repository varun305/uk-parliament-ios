import SwiftUI

struct ContextAwareNavigationLink<Label>: View where Label: View {
    @EnvironmentObject var contextModel: ContextModel

    private var value: NavigationItem
    private var label: () -> Label
    private var addChevron: Bool

    init(value: NavigationItem, addChevron: Bool = false, @ViewBuilder label: @escaping () -> Label) {
        self.value = value
        self.label = label
        self.addChevron = addChevron
    }

    var body: some View {
        if canLink() {
            NavigationLink(value: value) {
                labelView
            }
        } else {
            label()
        }
    }

    @ViewBuilder
    var labelView: some View {
        if addChevron {
            HStack {
                label()
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        } else {
            label()
        }
    }

    private func canLink() -> Bool {
        return !contextModel.navigationPath.contains(where: { $0 == value })
    }
}

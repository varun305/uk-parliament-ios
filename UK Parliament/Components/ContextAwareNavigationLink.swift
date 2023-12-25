import SwiftUI

struct ContextAwareNavigationLink<Label>: View where Label: View {
    @EnvironmentObject var contextModel: ContextModel

    private var value: NavigationItem
    private var label: () -> Label

    init(value: NavigationItem, @ViewBuilder label: @escaping () -> Label) {
        self.value = value
        self.label = label
    }

    var body: some View {
        if canLink() {
            NavigationLink(value: value) {
                label()
            }
        } else {
            label()
        }
    }

    private func canLink() -> Bool {
        return !clipepdPath().contains(where: { $0 == value })
    }

    private func clipepdPath() -> [NavigationItem] {
        if contextModel.navigationPath.count == 0 {
            return []
        } else {
            return Array(contextModel.navigationPath[0..<contextModel.navigationPath.count - 1])
        }
    }
}

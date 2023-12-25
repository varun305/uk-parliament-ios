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
        return !contextModel.navigationPath.contains(where: { $0 == value })
    }
}

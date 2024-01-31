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
        if forwardLink {
            NavigationLink(value: value) {
                label()
            }
        } else {
            label()
        }
    }

    private var forwardLink: Bool {
        !clipepdPath.contains(where: { $0 == value })
    }

    private var clipepdPath: [NavigationItem] {
        if contextModel.navigationPath.count == 0 {
            []
        } else {
            Array(contextModel.navigationPath[0..<contextModel.navigationPath.count - 1])
        }
    }
}

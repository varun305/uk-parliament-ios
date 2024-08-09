import SwiftUI

struct ContextAwareNavigationLink<Label>: View where Label: View {
    @EnvironmentObject var contextModel: ContextModel

    private var value: NavigationItem
    private var addChevron: Bool = true
    private var label: () -> Label

    init(value: NavigationItem, addChevron: Bool = true, @ViewBuilder label: @escaping () -> Label) {
        self.value = value
        self.label = label
        self.addChevron = addChevron
    }

    var body: some View {
        label()
            .if(forwardLink) { view in
                Button {
                    contextModel.manualNavigate(to: value)
                    print("NAVIGATED")
                } label: {
                    view
                        .if(addChevron) { view in
                            HStack {
                                view
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                                    .opacity(0.5)
                            }
                            .padding(.horizontal, 5)
                        }
                }
                .foregroundStyle(.primary)
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

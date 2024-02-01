import SwiftUI

struct DummyNavigationLink<Content: View>: View {

    var content: () -> Content

    init(content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        NavigationLink {
            Text("")
        } label: {
            content()
        }
        .disabled(true)
    }
}


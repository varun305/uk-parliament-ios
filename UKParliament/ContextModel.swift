import Foundation
import SwiftUI

class ContextModel: ObservableObject {
    @Published var navigationPath = [NavigationItem]()

    private func isViewInStack(_ view: NavigationItem) -> Bool {
        navigationPath.contains(view)
    }

    public func manualNavigate(to view: NavigationItem) {
        if !isViewInStack(view) {
            navigationPath.append(view)
        }
    }
}

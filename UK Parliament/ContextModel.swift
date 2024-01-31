import Foundation
import SwiftUI

class ContextModel: ObservableObject {
    @Published var navigationPath = [NavigationItem]()
}

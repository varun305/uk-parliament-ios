import Foundation
import SwiftUI

class MemberRegisteredInterestsViewModel: ObservableObject {
    @Published var registeredInterests: [RegisteredInterest] = []
    @Published var loading = false

    public func fetchData(for id: Int) {
        loading = true
        MemberRegisteredInterestModel.shared.getRegisteredInterests(for: id) { result in
            Task { @MainActor in
                withAnimation {
                    self.registeredInterests = result?.value ?? []
                    self.loading = false
                }
            }
        }
    }
}

import Foundation
import SwiftUI

class MemberContactViewModel: ObservableObject {
    @Published var contacts: [MemberContact] = []
    @Published var loading = false

    public func fetchContacts(for id: Int) {
        loading = true
        MemberModel.shared.fetchMemberContacts(for: id) { result in
            Task { @MainActor in
                withAnimation {
                    self.contacts = result?.value ?? []
                    self.loading = false
                }
            }
        }
    }
}

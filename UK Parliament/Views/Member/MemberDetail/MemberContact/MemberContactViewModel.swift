import Foundation


extension MemberContactView {
    @MainActor class MemberContactViewModel: ObservableObject {
        @Published var contacts: [MemberContact] = []

        public func fetchContacts(for id: Int) {
            MemberModel.shared.fetchMemberContacts(for: id) { result in
                Task { @MainActor in
                    self.contacts = result?.value ?? []
                }
            }
        }
    }
}

import Foundation


extension RegisteredInterestsView {
    @MainActor class RegisteredInterestsViewModel: ObservableObject {
        @Published var registeredInterests: [RegisteredInterest] = []

        public func fetchData(for id: Int) {
            RegisteredInterestModel.shared.getRegisteredInterests(for: id) { result in
                Task { @MainActor in
                    self.registeredInterests = result?.value ?? []
                }
            }
        }
    }
}

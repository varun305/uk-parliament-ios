import Foundation
import SwiftUI


extension BillPublicationsView {
    @MainActor class BillPublicationsViewModel: ObservableObject {
        @Published var loading = false
        @Published var publications: [BillPublication] = []

        public func fetchPublications(for id: Int) {
            loading = true
            BillModel.shared.fetchBillPublications(for: id) { result in
                Task { @MainActor in
                    self.publications = result?.publications ?? []
                    self.loading = false
                }
            }
        }
    }
}

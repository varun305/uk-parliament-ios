import Foundation
import SwiftUI

extension BillPublicationsView {
    @MainActor class BillPublicationsViewModel: ObservableObject {
        @Published var loading = false
        @Published var publications: [BillPublication] = []

        public func fetchPublications(for id: Int, stageId: Int? = nil) {
            loading = true
            if let stageId = stageId {
                BillModel.shared.fetchBillStagePublications(for: id, stageId: stageId) { result in
                    Task { @MainActor in
                        withAnimation {
                            self.publications = (result?.sittings ?? []).flatMap { $0.publications ?? [] }
                            self.loading = false
                        }
                    }
                }
            } else {
                BillModel.shared.fetchBillPublications(for: id) { result in
                    Task { @MainActor in
                        withAnimation {
                            self.publications = result?.publications ?? []
                            self.loading = false
                        }
                    }
                }
            }
        }
    }
}

import Foundation
import SwiftUI

extension BillPublicationsView {
    @MainActor class BillPublicationsViewModel: ObservableObject {
        @Published var loading = false
        @Published var publications: [BillPublication] = []
        @Published var search = ""
        var filteredPublications: [BillPublication] {
            publications.filter {
                $0.title?.searchContains(search) ?? false ||
                $0.publicationType?.name?.searchContains(search) ?? false
            }.reversedIf(!sortOrderAscending)
        }
        @Published var sortOrderAscending = true

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

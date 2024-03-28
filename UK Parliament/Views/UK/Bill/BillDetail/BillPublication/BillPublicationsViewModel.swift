import Foundation
import SwiftUI

class BillPublicationsViewModel: ObservableObject {
    var billId: Int?
    var stageId: Int?

    init(billId: Int? = nil, stageId: Int? = nil) {
        self.billId = billId
        self.stageId = stageId
        if let id = billId {
            self.typeFilters = BillModel.shared.billPublicationFilterCache[BillPublicationsFilterKey(billId: id, stageId: stageId)] ?? Set<String>()
        }
    }

    @Published var loading = false
    @Published var publications: [BillPublication] = []
    @Published var search = ""
    @Published var sortOrderAscending = true

    var filteredPublications: [BillPublication] {
        publications.reversedIf(!sortOrderAscending)
            .filter {
                $0.title?.searchContains(search) ?? false
            }.filter {
                if let type = $0.publicationType?.name {
                    typeFilters.contains(type) || typeFilters.isEmpty
                } else {
                    typeFilters.isEmpty
                }
            }
    }

    @Published var typeFilters = Set<String>() {
        didSet {
            if let id = billId {
                BillModel.shared.billPublicationFilterCache[BillPublicationsFilterKey(billId: id, stageId: stageId)] = typeFilters
            }
        }
    }

    var allPublicationTypes: Set<String> {
        Set(publications.compactMap { $0.publicationType?.name }.filter { $0 != "" })
    }

    public func fetchPublications() {
        if let id = billId {
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

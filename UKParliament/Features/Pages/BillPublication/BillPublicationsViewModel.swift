import Foundation
import SwiftUI
import Combine

class BillPublicationsViewModel: ObservableObject {
    var billId: Int?
    var stageId: Int?

    private var cancellables = Set<AnyCancellable>()

    init(billId: Int? = nil, stageId: Int? = nil) {
        self.billId = billId
        self.stageId = stageId
        if let id = billId {
            self.typeFilters = BillModel.shared.billPublicationFilterCache[BillPublicationsFilterKey(billId: id, stageId: stageId)] ?? Set<String>()
        }

        Publishers.CombineLatest4($publications, $search, $sortOrderAscending, $typeFilters)
            .debounce(for: .milliseconds(150), scheduler: DispatchQueue.main)
            .map { publications, search, ascending, filters in
                publications
                    .filter { pub in
                        guard let title = pub.title else { return false }
                        return title.searchContains(search)
                    }
                    .filter { pub in
                        guard !filters.isEmpty else { return true }
                        guard let type = pub.publicationType?.name else { return false }
                        return filters.contains(type)
                    }
                    .sorted { a, b in
                        let dateA = a.parsedDisplayDate ?? .distantPast
                        let dateB = b.parsedDisplayDate ?? .distantPast
                        return ascending ? dateA < dateB : dateA > dateB
                    }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$filteredPublications)

        $publications
            .map { pubs in
                Set(pubs.compactMap { $0.publicationType?.name }.filter { !$0.isEmpty })
            }
            .assign(to: &$allPublicationTypes)
    }

    @Published var loading = false
    @Published var publications: [BillPublication] = []
    @Published var search = ""
    @Published var sortOrderAscending = true
    @Published var filteredPublications: [BillPublication] = []
    @Published var allPublicationTypes: Set<String> = []

    @Published var typeFilters = Set<String>() {
        didSet {
            if let id = billId {
                BillModel.shared.billPublicationFilterCache[BillPublicationsFilterKey(billId: id, stageId: stageId)] = typeFilters
            }
        }
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

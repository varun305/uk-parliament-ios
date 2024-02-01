import Foundation
import SwiftUI
import Combine

@MainActor class BillsViewModel: ObservableObject {
    var member: Member? = nil
    @Published var loading = false
    @Published var result: BillItemModel?
    @Published var bills: [Bill] = []
    @Published var search = ""

    init(member: Member? = nil) {
        self.member = member
        addSearchSubscriber()
    }

    var numResults: Int {
        result?.totalResults ?? 0
    }

    private var cancellables = Set<AnyCancellable>()
    private func addSearchSubscriber() {
        $search
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.nextData(searchText: searchText, reset: true)
            }
            .store(in: &cancellables)
    }

    public func nextData(searchText: String? = nil, reset: Bool = false) {
        let search = searchText ?? self.search
        if !BillModel.shared.canGetNextData(search: search, reset: reset) {
            return
        }

        if reset {
            withAnimation {
                loading = true
                bills = []
            }
        }
        BillModel.shared.nextData(search: search, memberId: member?.id, reset: reset) { result in
            Task { @MainActor in
                withAnimation {
                    self.result = result
                    if reset {
                        self.bills = result?.items ?? []
                        self.loading = false
                    } else {
                        self.bills += result?.items ?? []
                    }
                }
            }
        }
    }
}

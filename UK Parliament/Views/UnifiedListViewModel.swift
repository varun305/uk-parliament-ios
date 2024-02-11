import Foundation
import SwiftUI
import Combine

@MainActor class UnifiedListViewModel<T: Identifiable>: ObservableObject {
    @Published var items = [T]()
    @Published var totalResults = 0
    @Published var search = ""
    @Published var loading = true

    init() {
        addSearchSubscriber()
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
        if !self.canFetchNextData(search: search, reset: reset) {
            return
        }

        if reset {
            withAnimation {
                loading = true
                items = []
            }
        }
        self.fetchNextData(search: search, reset: reset) { result, totalResults in
            Task { @MainActor in
                withAnimation {
                    self.items = result
                    self.totalResults = totalResults
                }
            }
        }
    }

    public func fetchNextData(search: String, reset: Bool, completion: @escaping ([T], Int) -> Void) {
        // OVERRIDE
        completion([], 0)
    }

    public func canFetchNextData(search: String, reset: Bool) -> Bool {
        // OVERRIDE
        return true
    }
}

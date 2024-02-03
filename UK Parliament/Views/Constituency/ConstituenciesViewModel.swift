import Foundation
import SwiftUI
import Combine

@MainActor class ConstituenciesViewModel: ObservableObject {
    @Published var consituencies: [Constituency] = []
    @Published var result: ConstituenciesModel?
    @Published var search = ""
    @Published var loading = true
    
    init() {
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
    
    func nextData(searchText: String? = nil, reset: Bool = false) {
        let search = searchText ?? self.search
        if !ConstituencyModel.shared.canGetNextData(search: search, reset: reset) {
            return
        }
        
        if reset {
            withAnimation {
                loading = true
                consituencies = []
            }
        }
        ConstituencyModel.shared.nextData(search: search, reset: reset) { result in
            let consituencies = (result?.items ?? []).compactMap { $0.value }
            Task { @MainActor in
                self.result = result
                withAnimation {
                    if reset {
                        self.consituencies = consituencies
                        self.loading = false
                    } else {
                        self.consituencies += consituencies
                    }
                }
            }
        }
    }
}

import Foundation
import SwiftUI
import Combine

@MainActor class MembersViewModel: ObservableObject {
    @Published var members: [Member] = []
    @Published var result: MembersModel?
    @Published var house: House = .commons {
        didSet {
            nextData(reset: true)
        }
    }
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
        if !MemberModel.shared.canGetNextData(search: search, reset: reset) {
            return
        }
        
        if reset {
            withAnimation {
                loading = true
                members = []
            }
        }
        MemberModel.shared.nextData(house: house, search: search, reset: reset) { result in
            let members = (result?.items ?? []).compactMap { $0.value }
            Task { @MainActor in
                self.result = result
                withAnimation {
                    if reset {
                        self.members = members
                        self.loading = false
                    } else {
                        self.members += members
                    }
                }
            }
        }
    }
}

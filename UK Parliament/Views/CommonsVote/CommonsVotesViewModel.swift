import Foundation
import SwiftUI
import Combine

@MainActor class CommonsVotesViewModel: ObservableObject {
    @Published var loading = true
    @Published var votes: [CommonsVote] = []
    @Published var search = ""

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
        if !VoteModel.shared.canGetNextData(search: search, reset: reset) {
            return
        }

        if reset {
            withAnimation {
                loading = true
                votes = []
            }
        }
        VoteModel.shared.nextCommonsData(search: search, reset: reset) { result in
            Task { @MainActor in
                withAnimation {
                    if reset {
                        self.votes = result ?? []
                        self.loading = false
                    } else {
                        self.votes += result ?? []
                    }
                }
            }
        }
    }
}

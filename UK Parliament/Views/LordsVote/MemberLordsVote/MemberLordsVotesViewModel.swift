import Foundation
import SwiftUI
import Combine

@MainActor class MemberLordsVotesViewModel: ObservableObject {
    var member: Member
    @Published var memberVotes: [MemberLordsVote] = []
    @Published var search = ""
    @Published var loading = true

    init(member: Member) {
        self.member = member
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
        if !MemberVoteModel.shared.canGetNextLordsData(search: search, reset: reset) {
            return
        }

        if reset {
            withAnimation {
                loading = true
                memberVotes = []
            }
        }
        if let memberId = member.id {
            MemberVoteModel.shared.nextMemberLordsData(memberId: memberId, search: search, reset: reset) { result in
                Task { @MainActor in
                    withAnimation {
                        if reset {
                            self.memberVotes = result ?? []
                            self.loading = false
                        } else {
                            self.memberVotes += result ?? []
                        }
                    }
                }
            }
        }
    }
}

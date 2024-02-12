import Foundation
import SwiftUI
import Combine

@MainActor class MemberCommonsVotesViewModel: UnifiedListViewModel<MemberCommonsVote> {
    var member: Member

    init(member: Member) {
        self.member = member
        super.init()
    }

    override internal func fetchNextData(search: String, reset: Bool, completion: @escaping ([MemberCommonsVote], Int) -> Void) {
        if let id = member.id {
            MemberVoteModel.shared.nextMemberCommonsData(memberId: id, search: search, reset: reset) { result in
                completion(result ?? [], 0)
            }
        } else {
            completion([], 0)
        }
    }

    override internal func canFetchNextData(search: String, reset: Bool) -> Bool {
        return MemberVoteModel.shared.canGetNextCommonsData(search: search, reset: reset)
    }
}

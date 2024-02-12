import Foundation
import SwiftUI
import Combine

@MainActor class CommonsVotesViewModel: UnifiedListViewModel<CommonsVote> {
    override internal func fetchNextData(search: String, reset: Bool, completion: @escaping ([CommonsVote], Int) -> Void) {
        VoteModel.shared.nextCommonsData(search: search, reset: reset) { result in
            completion(result ?? [], 0)
        }
    }

    override internal func canFetchNextData(search: String, reset: Bool) -> Bool {
        return VoteModel.shared.canGetNextCommonsData(search: search, reset: reset)
    }
}

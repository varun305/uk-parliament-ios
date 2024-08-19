import Foundation
import SwiftUI
import Combine

class LordsVotesViewModel: UnifiedListViewModel<LordsVote> {
    override internal func fetchNextData(search: String, reset: Bool, completion: @escaping ([LordsVote], Int) -> Void) {
        VoteModel.shared.nextLordsData(search: search, reset: reset) { result in
            completion(result ?? [], 0)
        }
    }

    override internal func canFetchNextData(search: String, reset: Bool) -> Bool {
        return VoteModel.shared.canGetNextLordsData(search: search, reset: reset)
    }
}

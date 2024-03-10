import Foundation
import SwiftUI

class LordsVoteDetailViewModel: ObservableObject {
    @Published var vote: LordsVote?
    @Published var loading = false

    public func fetchData(for id: Int) {
        loading = true
        VoteModel.shared.fetchLordsVote(for: id) { result in
            Task { @MainActor in
                withAnimation {
                    self.vote = result
                    self.loading = false
                }
            }
        }
    }
}

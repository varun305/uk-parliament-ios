import Foundation
import SwiftUI

class CommonsVoteDetailViewModel: ObservableObject {
    @Published var vote: CommonsVote?
    @Published var loading = false

    public func fetchData(for id: Int) {
        loading = true
        VoteModel.shared.fetchCommonsVote(for: id) { result in
            Task { @MainActor in
                withAnimation {
                    self.vote = result
                    self.loading = false
                }
            }
        }
    }
}

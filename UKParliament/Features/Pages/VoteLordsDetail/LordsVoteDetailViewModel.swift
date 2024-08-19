import Foundation
import SwiftUI

class LordsVoteDetailViewModel: ObservableObject {
    @Published var vote: LordsVote?
    @Published var loading = false

    @Published var contentsGrouping = [(PartyHashable, Int)]()
    @Published var notContentsGrouping = [(PartyHashable, Int)]()

    public func fetchData(for id: Int) {
        loading = true
        VoteModel.shared.fetchLordsVote(for: id) { result in
            Task { @MainActor in
                withAnimation {
                    self.vote = result
                    self.loading = false

                    if let ayes = result?.contents {
                        self.contentsGrouping = UtilsModel.groupVoters(ayes)
                    }
                    if let noes = result?.notContents {
                        self.notContentsGrouping = UtilsModel.groupVoters(noes)
                    }
                }
            }
        }
    }
}

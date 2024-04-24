import Foundation
import SwiftUI

class CommonsVoteDetailViewModel: ObservableObject {
    @Published var vote: CommonsVote?
    @Published var loading = false

    @Published var ayesGrouping = [(PartyHashable, Int)]()
    @Published var noesGrouping = [(PartyHashable, Int)]()

    public func fetchData(for id: Int) {
        loading = true
        VoteModel.shared.fetchCommonsVote(for: id) { result in
            Task { @MainActor in
                withAnimation {
                    self.vote = result
                    self.loading = false

                    if let ayes = result?.ayes {
                        self.ayesGrouping = UtilsModel.groupVoters(ayes)
                    }
                    if let noes = result?.noes {
                        self.noesGrouping = UtilsModel.groupVoters(noes)
                    }
                }
            }
        }
    }
}

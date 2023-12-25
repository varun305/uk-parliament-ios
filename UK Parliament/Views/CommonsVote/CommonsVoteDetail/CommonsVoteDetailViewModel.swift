import Foundation


extension CommonsVoteDetailView {
    @MainActor class CommonsVoteDetailViewModel: ObservableObject {
        @Published var vote: CommonsVote? = nil

        public func fetchData(for id: Int) {
            VoteModel.shared.fetchCommonsVote(for: id) { result in
                Task { @MainActor in
                    self.vote = result
                }
            }
        }
    }
}

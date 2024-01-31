import Foundation
import SwiftUI


extension CommonsVotesView {
    @MainActor class CommonsVotesViewModel: ObservableObject {
        @Published var loading = false
        @Published var votes: [CommonsVote] = []
        @Published var search = ""

        public func nextData(reset: Bool = false) {
            loading = true
            VoteModel.shared.nextCommonsData(search: search, reset: reset) { result in
                Task { @MainActor in
                    if let result = result {
                        withAnimation {
                            if reset {
                                self.votes = result
                            } else {
                                self.votes += result
                            }
                            self.loading = false
                        }
                    }
                }
            }
        }
    }
}

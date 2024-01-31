import Foundation

extension ConstituencyElectionDetailView {
    @MainActor class ConstituencyElectionDetailViewModel: ObservableObject {
        @Published var result: ElectionResult?

        public func fetchData(in constituencyId: Int, at election: ElectionResult) {
            if let electionId = election.id {
                ElectionResultModel.shared.getElectionResult(in: constituencyId, at: electionId) { result in
                    if let result = result {
                        Task { @MainActor in
                            self.result = result.value
                        }
                    }
                }
            }
        }
    }
}

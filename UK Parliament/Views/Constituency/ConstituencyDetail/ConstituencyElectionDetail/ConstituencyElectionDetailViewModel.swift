import Foundation


extension ConstituencyElectionDetailView {
    @MainActor class ConstituencyElectionDetailViewModel: ObservableObject {
        @Published var result: ElectionResult? = nil

        public func fetchData(in constituency: Constituency, at election: ElectionResult) {
            ElectionResultModel.shared.getElectionResult(in: constituency.id, at: election.id) { result in
                if let result = result {
                    Task { @MainActor in
                        self.result = result.value
                    }
                }
            }
        }
    }
}

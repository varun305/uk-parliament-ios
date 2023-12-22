import Foundation


extension ConstituencyDetailView {
    @MainActor class ConstituencyDetailViewModel: ObservableObject {
        @Published var electionResults: [ElectionResult] = []

        public func fetchData(for constituency: Constituency) {
            ElectionResultModel.shared.getResults(for: constituency.id) { result in
                if let result = result {
                    Task { @MainActor in
                        self.electionResults = result.value.sorted { $0.electionDate > $1.electionDate }
                    }
                }
            }
        }
    }
}

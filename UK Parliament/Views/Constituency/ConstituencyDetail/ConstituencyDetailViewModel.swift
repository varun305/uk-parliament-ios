import Foundation


extension ConstituencyDetailView {
    @MainActor class ConstituencyDetailViewModel: ObservableObject {
        @Published var constituency: Constituency? = nil
        @Published var electionResults: [ElectionResult] = []

        public func fetchConstituency(for id: Int) {
            ConstituencyModel.shared.getConstituency(for: id) { result in
                if let result = result {
                    Task { @MainActor in
                        self.constituency = result.value
                    }
                }
            }
        }

        public func fetchData(for id: Int) {
            ElectionResultModel.shared.getResults(for: id) { result in
                if let result = result {
                    Task { @MainActor in
                        self.electionResults = result.value.sorted { $0.electionDate > $1.electionDate }
                    }
                }
            }
        }
    }
}

import Foundation
import MapKit


extension ConstituencyDetailView {
    @MainActor class ConstituencyDetailViewModel: ObservableObject {
        @Published var constituency: Constituency? = nil
        @Published var electionResults: [ElectionResult] = []
        @Published var geometry: Geometry? = nil
        var coordinates: [[CLLocationCoordinate2D]] {
            geometry?.flattenedCoordinates.map {
                $0.map {
                    CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])
                }
            } ?? []
        }

        public func fetchConstituency(for id: Int) {
            ConstituencyModel.shared.getConstituency(for: id) { result in
                if let result = result {
                    Task { @MainActor in
                        self.constituency = result.value
                    }
                }
            }
        }

        public func fetchGeometry(for id: Int) {
            ConstituencyModel.shared.getConstituencyGeometry(for: id) { geometry in
                Task { @MainActor in
                    self.geometry = geometry
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

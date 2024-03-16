import Foundation
import MapKit
import SwiftUI

struct MapConfiguration: Identifiable {
   var constituency: Constituency
   var coordinates: [[[Double]]]
   var party: PartyModel?

   var id: Int? {
       constituency.id
   }
}

class ConstituencyDetailViewModel: ObservableObject {
    @Published var constituency: Constituency?
    @Published var electionResults: [ElectionResult] = []
    @Published var loading = false
    @Published var geometry: Geometry?

    public func fetchConstituency(for id: Int) {
        loading = true
        ConstituencyModel.shared.getConstituency(for: id) { result in
            Task { @MainActor in
                withAnimation {
                    self.constituency = result?.value
                    self.loading = false
                }
            }
        }
    }

    public func fetchGeometry(for id: Int) {
        ConstituencyModel.shared.getConstituencyGeometry(for: id) { geometry in
            Task { @MainActor in
                withAnimation {
                    self.geometry = geometry
                }
            }
        }
    }

    public func fetchElectionResults(for id: Int) {
        ElectionResultModel.shared.getResults(for: id) { result in
            Task { @MainActor in
                withAnimation {
                    self.electionResults = (result?.value ?? []).sorted { $0.formattedDate > $1.formattedDate }
                }
            }
        }
    }
}

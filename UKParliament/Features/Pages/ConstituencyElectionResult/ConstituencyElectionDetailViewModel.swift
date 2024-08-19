import Foundation
import SwiftUI

class ConstituencyElectionDetailViewModel: ObservableObject {
    @Published var result: ElectionResult?
    @Published var loading = false

    public func fetchData(in constituencyId: Int, at electionId: Int) {
        loading = true
        ElectionResultModel.shared.getElectionResult(in: constituencyId, at: electionId) { result in
            Task { @MainActor in
                withAnimation {
                    self.result = result?.value
                    self.loading = false
                }
            }
        }
    }
}

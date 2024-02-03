import Foundation
import SwiftUI

@MainActor class BillStagesViewModel: ObservableObject {
    @Published var loading = true
    @Published var result: StageResultModel?
    @Published var stages: [Stage] = []

    var numResults: Int {
        result?.totalResults ?? 0
    }

    public func nextData(for id: Int, reset: Bool = false) {
        if !BillModel.shared.canGetNextStagesData(for: id, reset: reset) {
            return
        }
        
        if reset {
            withAnimation {
                loading = true
                stages = []
            }
        }
        BillModel.shared.fetchBillStages(for: id, reset: reset) { result in
            Task { @MainActor in
                withAnimation {
                    self.result = result
                    if reset {
                        self.stages = result?.items ?? []
                    } else {
                        self.stages += result?.items ?? []
                    }
                    self.loading = false
                }
            }
        }
    }
}

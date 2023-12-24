import Foundation
import SwiftUI


extension BillStagesView {
    @MainActor class BillStagesViewModel: ObservableObject {
        @Published var result: StageResultModel? = nil
        @Published var stages: [Stage] = []

        var numResults: Int {
            result?.totalResults ?? 0
        }

        public func nextData(for id: Int, reset: Bool = false) {
            BillModel.shared.fetchBillStages(for: id, reset: reset) { result in
                if let result = result {
                    Task { @MainActor in
                        withAnimation {
                            self.result = result
                            if reset {
                                self.stages = result.items
                            } else {
                                self.stages += result.items
                            }
                        }
                    }
                }
            }
        }
    }
}

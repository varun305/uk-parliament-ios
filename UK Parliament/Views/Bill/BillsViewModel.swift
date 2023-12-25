import Foundation
import SwiftUI

extension BillsView {
    @MainActor class BillsViewModel: ObservableObject {
        @Published var result: BillItemModel?
        @Published var bills: [Bill] = []
        @Published var search = ""

        var numResults: Int {
            result?.totalResults ?? 0
        }

        private func handleData(result: BillItemModel?, reset: Bool = false) {
            if let result = result {
                let bills = result.items
                Task { @MainActor in
                    withAnimation {
                        self.result = result
                        if reset {
                            self.bills = bills
                        } else {
                            self.bills += bills
                        }
                    }
                }
            } else {
                // error
            }
        }

        public func nextData(reset: Bool = false) {
            BillModel.shared.nextData(search: search, reset: reset) { result in
                self.handleData(result: result, reset: reset)
            }
        }
    }
}

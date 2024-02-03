import Foundation
import SwiftUI

@MainActor class BillDetailViewModel: ObservableObject {
    @Published var loading = false
    @Published var bill: Bill?

    public func fetchData(for id: Int) {
        loading = true
        BillModel.shared.fetchBill(for: id) { result in
            Task { @MainActor in
                withAnimation {
                    self.bill = result
                    self.loading = false
                }
            }
        }
    }
}


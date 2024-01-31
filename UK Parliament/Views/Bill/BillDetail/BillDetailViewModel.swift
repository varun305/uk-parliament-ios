import Foundation

extension BillDetailView {
    @MainActor class BillDetailViewModel: ObservableObject {
        @Published var loading = false
        @Published var bill: Bill?

        public func fetchData(for id: Int) {
            loading = true
            BillModel.shared.fetchBill(for: id) { result in
                Task { @MainActor in
                    self.bill = result
                    self.loading = false
                }
            }
        }
    }
}

import Foundation
import SwiftUI

class BillStagesViewModel: UnifiedListViewModel<Stage> {
    var bill: Bill

    init(bill: Bill) {
        self.bill = bill
        super.init()
    }

    override internal func fetchNextData(search: String, reset: Bool, completion: @escaping ([Stage], Int) -> Void) {
        if let billId = bill.billId {
            BillModel.shared.fetchBillStages(for: billId, reset: reset) { result in
                completion(result?.items ?? [], result?.totalResults ?? 0)
            }
        } else {
            completion([], 0)
        }
    }

    override internal func canFetchNextData(search: String, reset: Bool) -> Bool {
        if let billId = bill.billId {
            return BillModel.shared.canGetNextStagesData(for: billId, reset: reset)
        } else {
            return false
        }
    }
}

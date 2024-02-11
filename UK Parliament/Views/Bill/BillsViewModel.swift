import Foundation
import SwiftUI
import Combine

@MainActor class BillsViewModel: UnifiedListViewModel<Bill> {
    var member: Member?

    init(member: Member? = nil) {
        self.member = member
        super.init()
    }

    override internal func fetchNextData(search: String, reset: Bool, completion: @escaping ([Bill], Int) -> Void) {
        BillModel.shared.nextData(search: search, memberId: member?.id, reset: reset) { result in
            completion(result?.items ?? [], result?.totalResults ?? 0)
        }
    }

    override internal func canFetchNextData(search: String, reset: Bool) -> Bool {
        return BillModel.shared.canGetNextData(search: search, memberId: member?.id, reset: reset)
    }
}

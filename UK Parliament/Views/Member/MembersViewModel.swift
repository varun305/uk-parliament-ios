import Foundation
import SwiftUI
import Combine

@MainActor class MembersViewModel: UnifiedListViewModel<Member> {
    var house: House
    
    init(house: House) {
        self.house = house
        super.init()
    }

    override internal func fetchNextData(search: String, reset: Bool, completion: @escaping ([Member], Int) -> Void) {
        MemberModel.shared.nextData(house: house, search: search, reset: reset) { result in
            completion((result?.items ?? []).compactMap { $0.value }, result?.totalResults ?? 0)
        }
    }

    override internal func canFetchNextData(search: String, reset: Bool) -> Bool {
        return MemberModel.shared.canGetNextData(house: house, search: search, reset: reset)
    }
}

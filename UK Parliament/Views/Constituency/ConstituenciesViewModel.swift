import Foundation
import SwiftUI
import Combine

@MainActor class ConstituenciesViewModel: UnifiedListViewModel<Constituency> {
    override internal func fetchNextData(search: String, reset: Bool, completion: @escaping ([Constituency], Int) -> Void) {
        ConstituencyModel.shared.nextData(search: search, reset: reset) { result in
            completion((result?.items ?? []).compactMap { $0.value }, result?.totalResults ?? 0)
        }
    }

    override internal func canFetchNextData(search: String, reset: Bool) -> Bool {
        return ConstituencyModel.shared.canGetNextData(search: search, reset: reset)
    }
}

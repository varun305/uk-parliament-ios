import Foundation
import SwiftUI


extension ConstituenciesView {
    @MainActor class ConstituenciesViewModel: ObservableObject {
        @Published var consituencies: [Constituency] = []
        @Published var result: ConstituenciesModel? = nil

        var numResults: Int {
            result?.totalResults ?? 0
        }

        func nextData() {
            ConstituencyModel.shared.nextData(skip: consituencies.count) { result in
                if let result = result {
                    let consituencies = result.items.map { $0.value }
                    Task { @MainActor in
                        self.result = result
                        self.consituencies += consituencies
                    }
                } else {
                    // error
                }
            }
        }
    }
}

import Foundation
import SwiftUI

extension ConstituenciesView {
    @MainActor class ConstituenciesViewModel: ObservableObject {
        @Published var consituencies: [Constituency] = []
        @Published var result: ConstituenciesModel?
        @Published var search = ""
        @Published var loading = false

        var numResults: Int {
            result?.totalResults ?? 0
        }

        private func handleData(result: ConstituenciesModel?, reset: Bool = false) {
            if let result = result {
                let consituencies = (result.items ?? []).compactMap { $0.value }
                Task { @MainActor in
                    self.result = result
                    withAnimation {
                        if reset {
                            self.consituencies = consituencies
                        } else {
                            self.consituencies += consituencies
                        }
                        self.loading = false
                    }
                }
            } else {
                // error
            }
        }

        func nextData(reset: Bool = false) {
            loading = true
            ConstituencyModel.shared.nextData(search: search, reset: reset) { result in
                self.handleData(result: result, reset: reset)
            }
        }
    }
}

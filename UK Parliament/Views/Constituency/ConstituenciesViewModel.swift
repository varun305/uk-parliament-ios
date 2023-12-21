import Foundation
import SwiftUI


extension ConstituenciesView {
    @MainActor class ConstituenciesViewModel: ObservableObject {
        @Published var consituencies: [Constituency] = []

        func nextData() {
            ConstituencyModel.shared.nextData { result in
                if let consituencies = result?.items.map { $0.value } {
                    Task { @MainActor in
                        withAnimation {
                            self.consituencies.append(contentsOf: consituencies)
                        }
                    }
                } else {
                    // error
                }
            }
        }
    }
}

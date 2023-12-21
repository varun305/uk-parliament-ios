import Foundation
import SwiftUI


extension PartiesView {
    @MainActor class PartiesViewModel: ObservableObject {
        @Published var state: StateOfThePartiesModel?
        @Published var house: House = .commons {
            didSet {
                fetchData()
            }
        }
        @Published var loading = false

        var parties: [PartyResultModel] {
            (state?.items ?? []).sorted { $0.value.total > $1.value.total }.map { $0.value }
        }

        func fetchData() {
            withAnimation {
                loading = true
            }

            let model = HouseModel()
            model.getHouseState(house: house) { state in
                Task { @MainActor in
                    self.state = state
                    withAnimation {
                        self.loading = false
                    }
                }
            }
        }
    }
}

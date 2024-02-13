import Foundation
import SwiftUI

class PartiesViewModel: ObservableObject {
    @Published var state: StateOfThePartiesModel?
    @Published var house: House = .commons {
        didSet {
            fetchData()
        }
    }
    @Published var loading = false

    var parties: [PartyResultModel] {
        (state?.items ?? []).sorted { $0.value?.total ?? 0 > $1.value?.total ?? 0 }.compactMap { $0.value }
    }

    func fetchData() {
        withAnimation {
            loading = true
        }

        HouseModel.shared.getHouseState(house: house) { state in
            Task { @MainActor in
                self.state = state
                withAnimation {
                    self.loading = false
                }
            }
        }
    }
}

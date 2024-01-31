import Foundation
import SwiftUI

class MembersViewModel: ObservableObject {
    @Published var members: [Member] = []
    @Published var result: MembersModel?
    @Published var house: House = .commons {
        didSet {
            nextData(reset: true)
        }
    }
    @Published var search = ""

    var numResults: Int {
        result?.totalResults ?? 0
    }

    private func handleData(result: MembersModel?, reset: Bool = false) {
        if let result = result {
            let members = (result.items ?? []).compactMap { $0.value }
            Task { @MainActor in
                self.result = result
                withAnimation {
                    if reset {
                        self.members = members
                    } else {
                        self.members += members
                    }
                }
            }
        } else {
            // error
        }
    }

    func nextData(reset: Bool = false) {
        MemberModel.shared.nextData(house: house, search: search == "" ? nil : search, reset: reset) { result in
            self.handleData(result: result, reset: reset)
        }
    }
}

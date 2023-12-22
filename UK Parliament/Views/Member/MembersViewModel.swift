import Foundation
import SwiftUI


class MembersViewModel: ObservableObject {
    @Published var members: [Member] = []
    @Published var result: MembersModel? = nil
    @Published var house: House = .commons {
        willSet {
            members = []
        }
        didSet {
            nextData()
        }
    }

    var numResults: Int {
        result?.totalResults ?? 0
    }

    func nextData() {
        MemberModel.shared.nextData(house: house, skip: members.count) { result in
            if let result = result {
                let members = result.items.map { $0.value }
                Task { @MainActor in
                    self.result = result
                    self.members += members
                }
            } else {
                // error
            }
        }
    }
}

import Foundation
import SwiftUI

class ScotlandMembersViewModel: ObservableObject {
    @Published var members = [ScotlandMember]()
    @Published var loading = false
    @Published var search = ""

    var filteredMembers: [ScotlandMember] {
        return members.filter {
            $0.isCurrent == true
        }.filter {
            search.isEmpty || ($0.parliamentaryName ?? "").lowercased().contains(search.lowercased())
        }.sorted {
            $0.parliamentaryName ?? "" < $1.parliamentaryName ?? ""
        }
    }

    func getData() {
        loading = true
        ScotlandMemberModel.shared.fetchData { result in
            Task { @MainActor in
                self.loading = false
                withAnimation {
                    self.members = result
                }
            }
        }
    }
}

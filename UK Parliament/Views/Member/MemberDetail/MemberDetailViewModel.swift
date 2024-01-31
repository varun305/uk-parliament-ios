import Foundation
import SwiftUI

extension MemberDetailView {
    @MainActor class MemberDetailViewModel: ObservableObject {
        @Published var member: Member? {
            didSet {
                if let membershipFromId = member?.latestHouseMembership?.membershipFromId {
                    fetchMemberConstituency(for: membershipFromId)
                }
                if let memberId = member?.id {
                    fetchMemberSynopsis(for: memberId)
                }
            }
        }
        @Published var constituency: Constituency?
        @Published var synopsis = ""
        @Published var loading = false

        public func fetchMember(for id: Int) {
            loading = true
            MemberModel.shared.fetchMember(for: id) { result in
                Task { @MainActor in
                    withAnimation {
                        self.member = result?.value
                        self.loading = false
                    }
                }
            }
        }

        public func fetchMemberConstituency(for id: Int) {
            ConstituencyModel.shared.getConstituency(for: id) { result in
                Task { @MainActor in
                    self.constituency = result?.value
                }
            }
        }

        public func fetchMemberSynopsis(for id: Int) {
            MemberModel.shared.fetchMemberSynopsis(for: id) { result in
                Task { @MainActor in
                    let string = result?.value ?? ""
                    do {
                        let regex = try NSRegularExpression(pattern: "(<[^>]*>)", options: .caseInsensitive)
                        let range = NSRange(location: 0, length: string.count)
                        let value = regex.stringByReplacingMatches(in: string, range: range, withTemplate: "")
                        self.synopsis = value
                    } catch {
                        self.synopsis = string
                    }
                }
            }
        }
    }
}

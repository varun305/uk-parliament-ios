import Foundation


class MemberCommonsVote: Codable, Identifiable, Hashable {
    var memberId: Int?
    var memberVotedAye: Bool?
    var memberWasTeller: Bool?
    var publishedDivision: CommonsVote?

    enum CodingKeys: String, CodingKey {
        case memberId = "MemberId"
        case memberVotedAye = "MemberVotedAye"
        case memberWasTeller = "MemberWasTeller"
        case publishedDivision = "PublishedDivision"
    }

    var id: Int? {
        publishedDivision?.id
    }

    static func == (lhs: MemberCommonsVote, rhs: MemberCommonsVote) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(publishedDivision)
    }
}

class MemberVoteModel {
    private var memberCommonsSkip: [String?: Int] = [nil: 0]
    private var memberCommonsReturn = [String?: Bool]()
    private let take = 20

    public static var shared = MemberVoteModel()
    private init() {}

    public func canGetNextData(search: String = "", reset: Bool = false) -> Bool {
        if reset {
            return true
        } 
        return !memberCommonsReturn[search, default: false]
    }

    public func nextMemberCommonsData(memberId: Int, search: String = "", reset: Bool = false, _ completion: @escaping ([MemberCommonsVote]?) -> Void) {
        if reset {
            memberCommonsSkip[search] = 0
            memberCommonsReturn[search] = false
        }

        let _skip = memberCommonsSkip[search, default: 0]
        if memberCommonsReturn[search, default: false] {
            completion(nil)
            return
        }

        let url = search == "" ? constructMemberCommonsVoteUrl(memberId: memberId, skip: _skip) : constructSearchMemberCommonsVote(memberId: memberId, search: search, skip: _skip)
        FetchModel.base.fetchData([MemberCommonsVote].self, from: url) { result in
            if let result = result {
                if result.isEmpty {
                    self.memberCommonsReturn[search] = true
                }
                self.memberCommonsSkip = [search: self.memberCommonsSkip[search, default: 0] + self.take]
            }
            completion(result)
        }
    }

    private func constructMemberCommonsVoteUrl(memberId: Int, skip: Int) -> String {
        "https://commonsvotes-api.parliament.uk/data/divisions.json/membervoting?queryParameters.memberId=\(memberId)&queryParameters.skip=\(skip)&queryParameters.take=\(take)"
    }

    private func constructSearchMemberCommonsVote(memberId: Int, search: String, skip: Int) -> String {
        "https://commonsvotes-api.parliament.uk/data/divisions.json/membervoting?queryParameters.memberId=\(memberId)&queryParameters.skip=\(skip)&queryParameters.take=\(take)&queryParameters.searchTerm=\(search)"
    }
}

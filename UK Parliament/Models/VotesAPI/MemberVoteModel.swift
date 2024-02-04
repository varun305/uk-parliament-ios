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

class MemberLordsVote: Codable, Identifiable, Hashable {
    var memberId: Int?
    var memberWasContent: Bool?
    var memberWasTeller: Bool?
    var publishedDivision: LordsVote?

    var id: Int? {
        publishedDivision?.id
    }

    static func == (lhs: MemberLordsVote, rhs: MemberLordsVote) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(publishedDivision)
    }
}

class MemberVoteModel {
    private var memberCommonsReturn = [String?: Bool]()
    private var memberLordsReturn = [String?: Bool]()

    public static var shared = MemberVoteModel()
    private init() {}

    public func canGetNextData(house: House, search: String = "", reset: Bool = false) -> Bool {
        return reset || house == .commons ? !memberCommonsReturn[search, default: false] : !memberLordsReturn[search, default: false]
    }

    public func canGetNextCommonsData(search: String = "", reset: Bool = false) -> Bool {
        self.canGetNextData(house: .commons, search: search, reset: reset)
    }

    public func nextMemberCommonsData(memberId: Int, search: String = "", reset: Bool = false, _ completion: @escaping ([MemberCommonsVote]?) -> Void) {
        if reset {
            memberCommonsReturn[search] = false
        }

        if memberCommonsReturn[search, default: false] {
            completion(nil)
            return
        }

        let url = constructMemberCommonsVoteUrl(memberId: memberId, search: search)
        FetchModel.base.fetchDataSkipTake([MemberCommonsVote].self, from: url) { result in
            if let result = result {
                if result.isEmpty {
                    self.memberCommonsReturn[search] = true
                }
            }
            completion(result)
        }
    }

    private let commonsVoteUrl = "https://commonsvotes-api.parliament.uk/data/divisions.json/membervoting"
    private func constructMemberCommonsVoteUrl(memberId: Int, search: String) -> URL {
        var components = URLComponents(string: commonsVoteUrl)!
        var queryItems = [URLQueryItem]()
        if !search.isEmpty {
            queryItems.append(URLQueryItem(name: "queryParameters.searchTerm", value: search))
        }
        queryItems.append(URLQueryItem(name: "queryParameters.memberId", value: String(memberId)))
        components.queryItems = queryItems
        return components.url!
    }

    public func canGetNextLordsData(search: String = "", reset: Bool = false) -> Bool {
        self.canGetNextData(house: .lords, search: search, reset: reset)
    }

    public func nextMemberLordsData(memberId: Int, search: String = "", reset: Bool = false, _ completion: @escaping ([MemberLordsVote]?) -> Void) {
        if reset {
            memberLordsReturn[search] = false
        }

        if memberLordsReturn[search, default: false] {
            completion(nil)
            return
        }

        let url = constructMemberLordsVoteUrl(memberId: memberId, search: search)
        FetchModel.base.fetchDataSkipTake([MemberLordsVote].self, from: url) { result in
            if let result = result {
                if result.isEmpty {
                    self.memberLordsReturn[search] = true
                }
            }
            completion(result)
        }
    }

    private let lordsVoteUrl = "https://lordsvotes-api.parliament.uk/data/Divisions/membervoting"
    private func constructMemberLordsVoteUrl(memberId: Int, search: String) -> URL {
        var components = URLComponents(string: lordsVoteUrl)!
        var queryItems = [URLQueryItem]()
        if !search.isEmpty {
            queryItems.append(URLQueryItem(name: "SearchTerm", value: search))
        }
        queryItems.append(URLQueryItem(name: "MemberId", value: String(memberId)))
        components.queryItems = queryItems
        return components.url!
    }
}

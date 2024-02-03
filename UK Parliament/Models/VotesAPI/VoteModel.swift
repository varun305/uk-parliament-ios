import Foundation

protocol Voter: Identifiable, Codable {
    var memberId: Int? { get }
    var name: String? { get }
    var listAs: String? { get }
    var party: String? { get }
    var partyColour: String? { get }
    var partyAbbreviation: String? { get }
    var memberFrom: String? { get }
}

class CommonsVoter: Voter {
    var memberId: Int?
    var name: String?
    var listAs: String?
    var party: String?
    var partyColour: String?
    var partyAbbreviation: String?
    var memberFrom: String?

    enum CodingKeys: String, CodingKey {
        case memberId = "MemberId"
        case name = "Name"
        case listAs = "ListAs"
        case party = "Party"
        case partyColour = "PartyColour"
        case partyAbbreviation = "PartyAbbreviation"
        case memberFrom = "MemberFrom"
    }

    var id: Int? {
        memberId
    }
}

class CommonsVote: Codable, Identifiable, Hashable {
    var divisionId: Int?
    var date: String?
    var publicationUpdated: String?
    var number: Int?
    var isDeferred: Bool?
    var title: String?
    var ayeCount: Int?
    var noCount: Int?
    var ayeTellers: [CommonsVoter]?
    var noTellers: [CommonsVoter]?
    var ayes: [CommonsVoter]?
    var noes: [CommonsVoter]?
    var noVoteRecorded: [CommonsVoter]?

    enum CodingKeys: String, CodingKey {
        case divisionId = "DivisionId"
        case date = "Date"
        case publicationUpdated = "PublicationUpdated"
        case number = "Number"
        case isDeferred = "IsDeferred"
        case title = "Title"
        case ayeCount = "AyeCount"
        case noCount = "NoCount"
        case ayeTellers = "AyeTellers"
        case noTellers = "NoTellers"
        case ayes = "Ayes"
        case noes = "Noes"
        case noVoteRecorded = "NoVoteRecorded"
    }

    var id: Int? {
        divisionId
    }

    static func == (lhs: CommonsVote, rhs: CommonsVote) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(divisionId)
        hasher.combine(title)
    }
}

class VoteModel {
    private var commonsReturn = [String?: Bool]()
    private let take = 20

    public static var shared = VoteModel()
    private init() {}

    public func canGetNextData(search: String = "", reset: Bool = false) -> Bool {
        if reset {
            return true
        }
        return !commonsReturn[search, default: false]
    }

    public func nextCommonsData(search: String = "", reset: Bool = false, _ completion: @escaping ([CommonsVote]?) -> Void) {
        if reset {
            commonsReturn[search] = false
        }

        if commonsReturn[search, default: false] {
            completion(nil)
            return
        }

        let url = constructCommonsVoteUrl(search: search)
        FetchModel.base.fetchDataSkipTake([CommonsVote].self, from: url, reset: reset) { result in
            if let result = result {
                if result.isEmpty {
                    self.commonsReturn[search] = true
                }
                self.commonsSkip = [search: self.commonsSkip[search, default: 0] + self.take]
            }
            completion(result)
        }
    }

    private let commonsVoteUrl = "https://commonsvotes-api.parliament.uk/data/divisions.json/search"
    private func constructCommonsVoteUrl(search: String) -> URL {
        var components = URLComponents(string: commonsVoteUrl)!
        var queryItems = [URLQueryItem]()
        if !search.isEmpty {
            queryItems.append(URLQueryItem(name: "queryParameters.searchTerm", value: search))
        }
        components.queryItems = queryItems
        return components.url!
    }

    public func fetchCommonsVote(for id: Int, _ completion: @escaping (CommonsVote?) -> Void) {
        let url = constructFetchCommonsVoteUrl(for: id)
        FetchModel.base.fetchData(CommonsVote.self, from: url) { result in
            completion(result)
        }
    }

    private func constructFetchCommonsVoteUrl(for id: Int) -> URL {
        URL(string: "https://commonsvotes-api.parliament.uk/data/division/\(id).json")!
    }
}

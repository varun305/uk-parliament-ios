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

class LordsVoter: Voter {
    var memberId: Int?
    var name: String?
    var listAs: String?
    var party: String?
    var partyColour: String?
    var partyAbbreviation: String?
    var memberFrom: String?

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

class LordsVote: Codable, Identifiable, Hashable {
    var divisionId: Int?
    var date: String?
    var number: Int?
    var notes: String?
    var title: String?
    var isWhipped: Bool?
    var isGovernmentContent: Bool?
    var authoritativeContentCount: Int?
    var authoritativeNotContentCount: Int?
    var sponsoringMemberId: Int?
    var isHouse: Bool?
    var amendmentNotes: String?
    var isGovernmentWin: Bool?
    var contentTellers: [LordsVoter]?
    var notContentTellers: [LordsVoter]?
    var contents: [LordsVoter]?
    var notContents: [LordsVoter]?

    var id: Int? {
        divisionId
    }

    static func == (lhs: LordsVote, rhs: LordsVote) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(divisionId)
        hasher.combine(title)
    }
}

class VoteModel {
    // TODO: need to change this whole system. it's disgusting
    private var commonsReturn = [String?: Bool]()
    private var lordsReturn = [String?: Bool]()

    public static var shared = VoteModel()
    private init() {}

    private func canGetNextData(house: House, search: String = "", reset: Bool = false) -> Bool {
        return reset || house == .commons ? !commonsReturn[search, default: false] : !lordsReturn[search, default: false]
    }

    public func canGetNextCommonsData(search: String = "", reset: Bool = false) -> Bool {
        self.canGetNextData(house: .commons, search: search, reset: reset)
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
        FetchModel.base.fetchDataSkipTake([CommonsVote].self, from: url, reset: reset, skipTakeParameters: .commonsVotes) { result in
            if let result = result {
                if result.isEmpty {
                    self.commonsReturn[search] = true
                }
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

    public func canGetNextLordsData(search: String = "", reset: Bool = false) -> Bool {
        self.canGetNextData(house: .lords, search: search, reset: reset)
    }

    public func nextLordsData(search: String = "", reset: Bool = false, _ completion: @escaping ([LordsVote]?) -> Void) {
        if reset {
            lordsReturn[search] = false
        }

        if lordsReturn[search, default: false] {
            completion(nil)
            return
        }

        let url = constructLordsVoteUrl(search: search)
        FetchModel.base.fetchDataSkipTake([LordsVote].self, from: url, reset: reset) { result in
            if let result = result {
                if result.isEmpty {
                    self.lordsReturn[search] = true
                }
            }
            completion(result)
        }
    }

    private let lordsVoteUrl = "https://lordsvotes-api.parliament.uk/data/Divisions/search"
    private func constructLordsVoteUrl(search: String) -> URL {
        var components = URLComponents(string: lordsVoteUrl)!
        var queryItems = [URLQueryItem]()
        if !search.isEmpty {
            queryItems.append(URLQueryItem(name: "SearchTerm", value: search))
        }
        components.queryItems = queryItems
        return components.url!
    }

    public func fetchLordsVote(for id: Int, _ completion: @escaping (LordsVote?) -> Void) {
        let url = constructFetchLordsVoteUrl(for: id)
        FetchModel.base.fetchData(LordsVote.self, from: url) { result in
            completion(result)
        }
    }

    private func constructFetchLordsVoteUrl(for id: Int) -> URL {
        URL(string: "https://lordsvotes-api.parliament.uk/data/Divisions/\(id)")!
    }
}

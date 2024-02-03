import Foundation

class MembershipModel: Codable, Equatable, Hashable {
    var membershipFrom: String?
    var membershipFromId: Int?
    var house: Int?
    var membershipStartDate: String?

    static func == (lhs: MembershipModel, rhs: MembershipModel) -> Bool {
        lhs.membershipFrom == rhs.membershipFrom
        && lhs.membershipFromId == rhs.membershipFromId
        && lhs.house == rhs.house
        && lhs.membershipStartDate == rhs.membershipStartDate
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(membershipFrom)
        hasher.combine(membershipFromId)
        hasher.combine(house)
        hasher.combine(membershipStartDate)
    }
}

class Member: Codable, Identifiable, Hashable {
    var id: Int?
    var nameListAs: String?
    var nameDisplayAs: String?
    var nameFullTitle: String?
    var nameAddressAs: String?
    var latestParty: PartyModel?
    var latestHouseMembership: MembershipModel?
    var gender: String?
    var thumbnailUrl: String?

    var isCommonsMember: Bool {
        latestHouseMembership?.house == 1
    }

    static func == (lhs: Member, rhs: Member) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(nameFullTitle)
    }
}

class MemberValueModel: Codable, Identifiable {
    var value: Member?
    var id: Int? {
        value?.id
    }
}

class MembersModel: Codable {
    var items: [MemberValueModel]?
    var totalResults: Int?
}

class MemberSynopsisModel: Codable {
    var value: String?
}

class MemberContact: Codable, Identifiable {
    var type: String?
    var typeDescription: String?
    var typeId: Int?
    var isPreferred: Bool?
    var isWebAddress: Bool?
    var notes: String?
    var line1: String?
    var line2: String?
    var postcode: String?
    var phone: String?
    var email: String?

    var id: String {
        (line1 ?? "") + (type ?? "")
    }
}

class MemberContactValueModel: Codable {
    var value: [MemberContact]?
}

class MemberModel {
    private var skip: [String?: Int] = [nil: 0]
    private var take = 20
    private var totalResults: Int = .max

    public static var shared = MemberModel()
    private init() {}

    public func fetchMember(for id: Int, _ completion: @escaping (MemberValueModel?) -> Void) {
        let url = constructMemberUrl(for: id)
        FetchModel.base.fetchData(MemberValueModel.self, from: url) { result in
            completion(result)
        }
    }

    private func constructMemberUrl(for id: Int) -> URL {
        URL(string: "https://members-api.parliament.uk/api/Members/\(id)")!
    }

    public func fetchMemberSynopsis(for id: Int, _ completion: @escaping (MemberSynopsisModel?) -> Void) {
        let url = constructMemberSynopsisUrl(for: id)
        FetchModel.base.fetchData(MemberSynopsisModel.self, from: url) { result in
            completion(result)
        }
    }

    private func constructMemberSynopsisUrl(for id: Int) -> URL {
        URL(string: "https://members-api.parliament.uk/api/Members/\(id)/Synopsis")!
    }

    public func fetchMemberContacts(for id: Int, _ completion: @escaping (MemberContactValueModel?) -> Void) {
        let url = constructMemberContactUrl(for: id)
        FetchModel.base.fetchData(MemberContactValueModel.self, from: url) { result in
            completion(result)
        }
    }

    private func constructMemberContactUrl(for id: Int) -> URL {
        URL(string: "https://members-api.parliament.uk/api/Members/\(id)/Contact")!
    }

    public func canGetNextData(search: String = "", reset: Bool = false) -> Bool {
        if reset {
            return true
        }
        return !(skip[search, default: 0] > totalResults)
    }

    public func nextData(house: House, search: String = "", reset: Bool = false, _ completion: @escaping (MembersModel?) -> Void) {
        let url = constructMembersUrl(search: search, house: house)
        FetchModel.base.fetchDataSkipTake(MembersModel.self, from: url, reset: reset) { result in
            if let result = result {
                self.totalResults = result.totalResults ?? 0
                self.skip = [search: self.skip[search, default: 0] + self.take]
                completion(result)
            } else {
                completion(nil)
            }
        }
    }

    private let membersUrl = "https://members-api.parliament.uk/api/Members/Search"

    private func constructMembersUrl(search: String, house: House) -> URL {
        var components = URLComponents(string: membersUrl)!
        var queryItems = [URLQueryItem]()
        if !search.isEmpty {
            queryItems.append(URLQueryItem(name: "Name", value: search))
        }
        queryItems += [
            URLQueryItem(name: "House", value: String(house.rawValue)),
            URLQueryItem(name: "IsEligible", value: "true")
        ]
        components.queryItems = queryItems
        return components.url!
    }
}

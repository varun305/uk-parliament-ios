import Foundation


class MembdershipModel: Codable {
    var membershipFrom: String
    var membershipFromId: Int
    var house: Int
    var membershipStartDate: String
}

class Member: Codable, Identifiable {
    var id: Int
    var nameListAs: String
    var nameDisplayAs: String
    var nameFullTitle: String
    var nameAddressAs: String?
    var latestParty: PartyModel
    var latestHouseMembership: MembdershipModel
    var gender: String
    var thumbnailUrl: String

    var isCommonsMember: Bool {
        latestHouseMembership.house == 1
    }
}

class MemberValueModel: Codable, Identifiable {
    var value: Member
    var id: Int {
        value.id
    }
}

class MembersModel: Codable {
    var items: [MemberValueModel]
    var totalResults: Int
}

class MemberSynopsisModel: Codable {
    var value: String
}

class MemberContact: Codable, Identifiable {
    var type: String
    var typeDescription: String?
    var typeId: Int
    var isPreferred: Bool
    var isWebAddress: Bool
    var notes: String?
    var line1: String
    var line2: String?
    var postcode: String?
    var phone: String?
    var email: String?

    var id: String {
        line1 + type
    }
}

class MemberContactValueModel: Codable {
    var value: [MemberContact]
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

    private func constructMemberUrl(for id: Int) -> String {
        "https://members-api.parliament.uk/api/Members/\(id)"
    }

    public func fetchMemberSynopsis(for id: Int, _ completion: @escaping (MemberSynopsisModel?) -> Void) {
        let url = constructMemberSynopsisUrl(for: id)
        FetchModel.base.fetchData(MemberSynopsisModel.self, from: url) { result in
            completion(result)
        }
    }

    private func constructMemberSynopsisUrl(for id: Int) -> String {
        "https://members-api.parliament.uk/api/Members/\(id)/Synopsis"
    }

    public func fetchMemberContacts(for id: Int, _ completion: @escaping (MemberContactValueModel?) -> Void) {
        let url = constructMemberContactUrl(for: id)
        FetchModel.base.fetchData(MemberContactValueModel.self, from: url) { result in
            completion(result)
        }
    }

    private func constructMemberContactUrl(for id: Int) -> String {
        "https://members-api.parliament.uk/api/Members/\(id)/Contact"
    }

    public func nextData(house: House, search: String? = nil, reset: Bool = false, _ completion: @escaping (MembersModel?) -> Void) {
        if reset {
            skip[search] = 0
        }

        let _skip = skip[search, default: 0]
        if _skip > totalResults {
            return
        }

        let url = search == nil ? constructMembersUrl(house: house, skip: _skip) : constructSearchMembersUrl(search: search!, house: house, skip: _skip)
        skip.forEach { key, _ in
            if key != search {
                skip[key] = 0
            }
        }

        FetchModel.base.fetchData(MembersModel.self, from: url) { result in
            if let result = result {
                self.totalResults = result.totalResults
                self.skip[search] = self.skip[search, default: 0] + self.take
                completion(result)
            } else {
                completion(nil)
            }
        }
    }

    private func constructMembersUrl(house: House, skip: Int) -> String {
        "https://members-api.parliament.uk/api/Members/Search?House=\(house.rawValue)&IsEligible=true&skip=\(skip)&take=\(take)"
    }

    private func constructSearchMembersUrl(search: String, house: House, skip: Int) -> String {
        "https://members-api.parliament.uk/api/Members/Search?Name=\(search)&House=\(house.rawValue)&IsEligible=true&skip=\(skip)&take=\(take)"
    }
}

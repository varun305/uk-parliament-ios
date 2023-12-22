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


class MemberModel: FetchModel {
    private var skip: [String?: Int] = [nil: 0]
    private var take = 20
    private var totalResults: Int = .max

    public static var shared = MemberModel()
    override private init() {
        super.init()
    }

    public func nextData(house: House, search: String? = nil, reset: Bool = false, _ completion: @escaping (MembersModel?) -> Void) {
        if reset {
            skip[search] = 0
        }

        let _skip = skip[search, default: 0]
        if _skip >= totalResults {
            return
        }

        let url = search == nil ? constructMembersUrl(house: house, skip: _skip) : constructSearchMembersUrl(search: search!, house: house, skip: _skip)
        skip.forEach { key, _ in
            if key != search {
                skip[key] = 0
            }
        }

        FetchModel.base.fetchData(from: url) { data in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(MembersModel.self, from: data)
                    self.totalResults = result.totalResults
                    self.skip[search] = self.skip[search, default: 0] + self.take
                    completion(result)
                } catch let error {
                    print(error)
                    completion(nil)
                }
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

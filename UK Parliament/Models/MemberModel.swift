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
    private var skip = 0
    private var take = 20
    private var totalResults: Int = .max

    public static var shared = MemberModel()
    override private init() {
        super.init()
    }

    public func nextData(house: House, skip: Int? = nil, _ completion: @escaping (MembersModel?) -> Void) {
        let _skip = skip ?? self.skip
        if _skip >= totalResults {
            return
        }

        let url = constructMembersUrl(house: house, skip: _skip)
        FetchModel.base.fetchData(from: url) { data in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(MembersModel.self, from: data)
                    self.totalResults = result.totalResults
                    self.skip += self.take
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
}

import Foundation


class Member: Codable, Identifiable {
    var id: Int
    var nameListAs: String
    var nameDisplayAs: String
    var nameFullTitle: String
    var nameAddressAs: String?
    var latestParty: PartyModel
    var gender: String
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


fileprivate struct SearchParams: Hashable {
    var skip: Int
    var take: Int
    var house: House
}

class MemberModel {
    private var skip = 0
    private var take = 20
    private var totalResults: Int = .max

    private var cache: [SearchParams: MembersModel] = [:]

    public static var shared = MemberModel()
    private init() {}

    public func nextData(house: House, skip: Int? = nil, _ completion: @escaping (MembersModel?) -> Void) {
        let _skip = skip ?? self.skip
        if _skip >= totalResults {
            return
        }

        let searchParams = SearchParams(skip: _skip, take: take, house: house)
        guard cache[searchParams] == nil else {
            completion(cache[searchParams])
            return
        }

        let url = URL(string: "https://members-api.parliament.uk/api/Members/Search?House=\(house.rawValue)&IsEligible=true&skip=\(_skip)&take=\(take)")!
        print("FETCHING skip=\(_skip) take=\(take)")
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let result = try JSONDecoder().decode(MembersModel.self, from: data)
                    self.totalResults = result.totalResults
                    self.skip += self.take
                    self.cache[searchParams] = result
                    completion(result)
                } catch let error {
                    print(error)
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}

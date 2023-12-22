import Foundation


class CurrentRepresentationModel: Codable {
    var member: MemberValueModel
}

class Constituency: Codable, Identifiable {
    var id: Int
    var name: String
    var startDate: String
    var endDate: String?
    var currentRepresentation: CurrentRepresentationModel
    var member: Member {
        currentRepresentation.member.value
    }
}

class ConstituencyValueModel: Codable, Identifiable {
    var value: Constituency
    var id: Int {
        value.id
    }
}

class ConstituenciesModel: Codable {
    var items: [ConstituencyValueModel]
    var links: [[String: String]]
    var totalResults: Int
}


class ConstituencyModel: FetchModel {
    private var skip = 0
    private var take = 20
    private var totalResults: Int = .max

    public static var shared = ConstituencyModel()
    override private init() {
        super.init()
    }

    public func nextData(skip: Int? = nil, _ completion: @escaping (ConstituenciesModel?) -> Void) {
        let _skip = skip ?? self.skip
        if _skip >= totalResults {
            return
        }

        let url = constructConstituenciesUrl(skip: _skip)
        FetchModel.base.fetchData(from: url) { data in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(ConstituenciesModel.self, from: data)
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

    private func constructConstituenciesUrl(skip: Int) -> String {
        "https://members-api.parliament.uk/api/Location/Constituency/Search?skip=\(skip)&take=\(take)"
    }
}

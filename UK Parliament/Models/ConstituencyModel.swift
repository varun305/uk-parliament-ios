import Foundation


class CurrentRepresentationModel: Codable {
    var member: MemberValueModel
}

class Constituency: Codable, Identifiable {
    var id: Int
    var name: String
    var startDate: String
    var endDate: String?
    var currentRepresentation: CurrentRepresentationModel?
    var member: Member? {
        currentRepresentation?.member.value
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
    private var skip: [String?: Int] = [nil: 0]
    private let take = 20
    private var totalResults: Int = .max

    public static var shared = ConstituencyModel()
    override private init() {
        super.init()
    }

    public func getConstituency(for id: Int, _ completion: @escaping (ConstituencyValueModel?) -> Void) {
        let url = getConstituencyUrl(for: id)
        FetchModel.base.fetchData(from: url) { data in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(ConstituencyValueModel.self, from: data)
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

    private func getConstituencyUrl(for id: Int) -> String {
        "https://members-api.parliament.uk/api/Location/Constituency/\(id)"
    }

    public func nextData(search: String = "", reset: Bool = false, _ completion: @escaping (ConstituenciesModel?) -> Void) {
        if reset {
            skip[search] = 0
        }

        let _skip = skip[search, default: 0]
        if _skip > totalResults {
            return
        }

        let url = search == "" ? constructConstituenciesUrl(skip: _skip) : constructSearchConstituenciesUrl(search: search, skip: _skip)
        skip.forEach { key, _ in
            if key != search {
                skip[key] = 0
            }
        }
        
        FetchModel.base.fetchData(from: url) { data in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(ConstituenciesModel.self, from: data)
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

    private func constructConstituenciesUrl(skip: Int) -> String {
        "https://members-api.parliament.uk/api/Location/Constituency/Search?skip=\(skip)&take=\(take)"
    }

    private func constructSearchConstituenciesUrl(search: String, skip: Int) -> String {
        "https://members-api.parliament.uk/api/Location/Constituency/Search?searchText=\(search)&skip=\(skip)&take=\(take)"
    }
}

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
    var member: MemberModel {
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


fileprivate struct SearchParams: Hashable {
    var skip: Int
    var take: Int
}


class ConstituencyModel: ObservableObject {
    private var skip = 0
    private var take = 20
    private var totalResults: Int = .max

    private var cache: [SearchParams: ConstituenciesModel] = [:]

    public static var shared = ConstituencyModel()
    private init() {}

    public func nextData(skip: Int? = nil, _ completion: @escaping (ConstituenciesModel?) -> Void) {
        let _skip = skip ?? self.skip
        if _skip >= totalResults {
            return
        }

        let searchParams = SearchParams(skip: _skip, take: take)
        guard cache[searchParams] == nil else {
            completion(cache[searchParams])
            return
        }

        let url = URL(string: "https://members-api.parliament.uk/api/Location/Constituency/Search?skip=\(_skip)&take=\(take)")!
        print("FETCHING skip=\(_skip) take=\(take)")
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let result = try JSONDecoder().decode(ConstituenciesModel.self, from: data)
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

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

protocol Geometry {
    var flattenedCoordinates: [[[Double]]] { get }
}

class SingleGeometry: Codable, Geometry {
    var type: String
    var coordinates: [[[Double]]]

    var flattenedCoordinates: [[[Double]]] {
        coordinates
    }
}

class MultiGeometry: Codable, Geometry {
    var type: String
    var coordinates: [[[[Double]]]]

    var flattenedCoordinates: [[[Double]]] {
        coordinates.flatMap { $0 }
    }
}

class ConstituencyGeometryValueModel: Codable {
    var value: String
}

class ConstituencyModel {
    private var skip: [String?: Int] = [nil: 0]
    private let take = 20
    private var totalResults: Int = .max

    public static var shared = ConstituencyModel()
    private init() {}

    public func getConstituencyGeometry(for id: Int, _ completion: @escaping (Geometry?) -> Void) {
        let url = constructConstituencyGeometryUrl(for: id)
        FetchModel.base.fetchData(ConstituencyGeometryValueModel.self, from: url) { result in
            if let result = result {
                do {
                    let geometry = try JSONDecoder().decode(SingleGeometry.self, from: Data(result.value.utf8))
                    completion(geometry)
                } catch {
                    do {
                        let multiGeometry = try JSONDecoder().decode(MultiGeometry.self, from: Data(result.value.utf8))
                        completion(multiGeometry)
                    } catch let error {
                        print(error)
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }

    private func constructConstituencyGeometryUrl(for id: Int) -> String {
        "https://members-api.parliament.uk/api/Location/Constituency/\(id)/Geometry"
    }

    public func getConstituency(for id: Int, _ completion: @escaping (ConstituencyValueModel?) -> Void) {
        let url = constructConstituencyUrl(for: id)
        FetchModel.base.fetchData(ConstituencyValueModel.self, from: url) { result in
            completion(result)
        }
    }

    private func constructConstituencyUrl(for id: Int) -> String {
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

        FetchModel.base.fetchData(ConstituenciesModel.self, from: url) { result in
            if let result = result {
                self.totalResults = result.totalResults
                self.skip = [search: self.skip[search, default: 0] + self.take]
                completion(result)
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

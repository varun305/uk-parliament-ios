import Foundation

class CurrentRepresentationModel: Codable {
    var member: MemberValueModel?
}

class Constituency: Codable, Identifiable, Hashable {
    var id: Int?
    var name: String?
    var startDate: String?
    var endDate: String?
    var currentRepresentation: CurrentRepresentationModel?
    var member: Member? {
        currentRepresentation?.member?.value
    }

    static func == (lhs: Constituency, rhs: Constituency) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}

class ConstituencyValueModel: Codable, Identifiable {
    var value: Constituency?
    var id: Int? {
        value?.id
    }
}

class ConstituenciesModel: Codable {
    var items: [ConstituencyValueModel]?
    var links: [[String: String]]?
    var totalResults: Int?
}

protocol Geometry {
    var flattenedCoordinates: [[[Double]]]? { get }
}

class SingleGeometry: Codable, Geometry {
    var type: String?
    var coordinates: [[[Double]]]?

    var flattenedCoordinates: [[[Double]]]? {
        coordinates
    }
}

class MultiGeometry: Codable, Geometry {
    var type: String?
    var coordinates: [[[[Double]]]]?

    var flattenedCoordinates: [[[Double]]]? {
        (coordinates ?? []).flatMap { $0 }
    }
}

class ConstituencyGeometryValueModel: Codable {
    var value: String?
}

class ConstituencyModel {
    private var totalResults: Int = .max

    public static var shared = ConstituencyModel()
    private init() {}

    public func getConstituencyGeometry(for id: Int, _ completion: @escaping (Geometry?) -> Void) {
        let url = constructConstituencyGeometryUrl(for: id)
        FetchModel.base.fetchData(ConstituencyGeometryValueModel.self, from: url) { result in
            if let result = result {
                do {
                    let geometry = try JSONDecoder().decode(SingleGeometry.self, from: Data((result.value ?? "").utf8))
                    completion(geometry)
                } catch {
                    do {
                        let multiGeometry = try JSONDecoder().decode(MultiGeometry.self, from: Data((result.value ?? "").utf8))
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

    private func constructConstituencyGeometryUrl(for id: Int) -> URL {
        URL(string: "https://members-api.parliament.uk/api/Location/Constituency/\(id)/Geometry")!
    }

    public func getConstituency(for id: Int, _ completion: @escaping (ConstituencyValueModel?) -> Void) {
        let url = constructConstituencyUrl(for: id)
        FetchModel.base.fetchData(ConstituencyValueModel.self, from: url) { result in
            completion(result)
        }
    }

    private func constructConstituencyUrl(for id: Int) -> URL {
        URL(string: "https://members-api.parliament.uk/api/Location/Constituency/\(id)")!
    }

    public func canGetNextData(search: String = "", reset: Bool = false) -> Bool {
        if reset {
            return true
        }
        let url = constructConstituenciesUrl(search: search)
        return FetchModel.base.canGetNextData(from: url, totalResults: totalResults)
    }

    public func nextData(search: String = "", reset: Bool = false, _ completion: @escaping (ConstituenciesModel?) -> Void) {
        let url = constructConstituenciesUrl(search: search)
        FetchModel.base.fetchData(ConstituenciesModel.self, from: url) { result in
            if let result = result {
                self.totalResults = result.totalResults ?? 0
                completion(result)
            } else {
                completion(nil)
            }
        }
    }

    private let constituenciesUrl = "https://members-api.parliament.uk/api/Location/Constituency/Search"
    private func constructConstituenciesUrl(search: String) -> URL {
        var components = URLComponents(string: constituenciesUrl)!
        var queryItems = [URLQueryItem]()
        if !search.isEmpty {
            queryItems.append(URLQueryItem(name: "searchText", value: search))
        }
        components.queryItems = queryItems
        return components.url!
    }
}

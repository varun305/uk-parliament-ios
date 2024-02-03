import Foundation

class UtilsModel {
    public static func constructURLHashable(from url: URL) -> Set<String> {
        var result = Set<String>()
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        result.insert(components.path)
        result.insert(components.host!)
        components.queryItems?.forEach { result.insert("\($0.name)=\($0.value ?? "")") }
        return result
    }

    public static func addURLQueries(to url: URL, queries: [URLQueryItem]) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = (components.queryItems ?? []) + queries
        return components.url!
    }

    public static func resolveData<T>(_ type: T.Type, from data: Data?) -> T? where T: Decodable {
        if let data = data {
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch let error {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }
}

import Foundation


class FetchModel {
    var cache: [String: Data] = [:]

    public static var base = FetchModel()
    public init() {}

    public func fetchData<T>(_ type: T.Type, from url: String, _ completion: @escaping (T?) -> Void) where T: Decodable {
        guard cache[url] == nil else {
            completion(resolveData(T.self, from: cache[url]))
            return
        }

        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            print("FETCHING \(url)")
            self.cache[url] = data
            completion(self.resolveData(T.self, from: data))
        }.resume()
    }

    private func resolveData<T>(_ type: T.Type, from data: Data?) -> T? where T: Decodable {
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

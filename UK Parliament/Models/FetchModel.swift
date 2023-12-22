import Foundation


class FetchModel {
    var cache: [String: Data] = [:]

    public static var base = FetchModel()
    public init() {}

    internal func fetchData(from url: String, _ completion: @escaping (Data?) -> Void) {
        guard cache[url] == nil else {
            completion(cache[url])
            return
        }

        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            print("FETCHING \(url)")
            self.cache[url] = data
            completion(data)
        }.resume()
    }
}

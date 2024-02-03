import Foundation

class FetchModel {
    var cache = [URL: Data]()
    private var paginationCache = [Set<String>: SkipTakeModel]()

    public static var base = FetchModel()
    public init() {}

    public func fetchData(from url: URL, _ completion: @escaping (Data?) -> Void) {
        guard cache[url] == nil else {
            completion(cache[url])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            print("FETCHING \(url)")
            self.cache[url] = data
            completion(data)
        }.resume()
    }

    public func fetchDataSkipTake<T>(_ type: T.Type, from url: URL, reset: Bool = false, _ completion: @escaping (T?) -> Void) where T: Decodable {
        let hashable = UtilsModel.constructURLHashable(from: url)
        
        if reset {
            paginationCache[hashable] = .reset
        }
        let skipTake = paginationCache[hashable, default: .reset]

        let skip = skipTake.skip
        let take = skipTake.take
        let newUrl = UtilsModel.addURLQueries(to: url, queries: [
            URLQueryItem(name: "skip", value: String(skip)),
            URLQueryItem(name: "take", value: String(take))
        ])

        paginationCache[hashable] = paginationCache[hashable, default: .reset].updated(20)
        FetchModel.base.fetchData(type, from: newUrl) { completion($0) }
    }

    public func fetchData<T>(_ type: T.Type, from url: URL, _ completion: @escaping (T?) -> Void) where T: Decodable {
        guard cache[url] == nil else {
            completion(UtilsModel.resolveData(T.self, from: cache[url]))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            print("FETCHING \(url)")
            self.cache[url] = data
            completion(UtilsModel.resolveData(T.self, from: data))
        }.resume()
    }

    public func canGetNextData(from url: URL, totalResults: Int) -> Bool {
        let hashable = UtilsModel.constructURLHashable(from: url)
        return paginationCache[hashable, default: .reset].skip >= totalResults
    }
}

private struct SkipTakeModel {
    var skip: Int
    var take: Int

    static var reset = SkipTakeModel(skip: 0, take: 0)
    public func updated(_ taken: Int) -> SkipTakeModel {
        return SkipTakeModel(skip: skip + taken, take: take)
    }
}

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

        print("FETCHING \(url)")
        URLSession.shared.dataTask(with: url) { data, _, _ in
            self.cache[url] = data
            completion(data)
        }.resume()
    }

    public func fetchDataSkipTake<T>(
        _ type: T.Type,
        from url: URL,
        reset: Bool,
        skipTakeParameters: SkipTakeParameters = .normal,
        _ completion: @escaping (T?) -> Void
    ) where T: Decodable {
        let hashable = UtilsModel.constructURLHashable(from: url)
        
        if reset {
            paginationCache[hashable] = .reset
        }
        let skipTake = paginationCache[hashable, default: .reset]

        let skip = skipTake.skip
        let take = skipTake.take
        let newUrl = UtilsModel.addURLQueries(to: url, queries: [
            URLQueryItem(name: skipTakeParameters.skip, value: String(skip)),
            URLQueryItem(name: skipTakeParameters.take, value: String(take))
        ])

        paginationCache[hashable] = paginationCache[hashable, default: .reset].updated(20)
        FetchModel.base.fetchData(type, from: newUrl) { completion($0) }
    }

    public func fetchData<T>(_ type: T.Type, from url: URL, _ completion: @escaping (T?) -> Void) where T: Decodable {
        guard cache[url] == nil else {
            completion(UtilsModel.resolveData(T.self, from: cache[url]))
            return
        }

        print("FETCHING \(url)")
        URLSession.shared.dataTask(with: url) { data, _, _ in
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

    static var reset = SkipTakeModel(skip: 0, take: 20)
    public func updated(_ taken: Int) -> SkipTakeModel {
        return SkipTakeModel(skip: skip + taken, take: take)
    }
}

struct SkipTakeParameters {
    var skip: String
    var take: String

    static var normal = SkipTakeParameters(skip: "skip", take: "take")
    static var commonsVotes = SkipTakeParameters(skip: "queryParameters.skip", take: "queryParameters.take")
}

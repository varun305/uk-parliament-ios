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

    public static func groupVoters(_ voters: [any Voter]) -> [(PartyHashable, Int)] {
        var results = [PartyHashable: Int]()
        for voter in voters {
            if let party = voter.party {
                let hashable = PartyHashable(party: party, partyColour: voter.partyColour, partyAbbreviation: voter.partyAbbreviation)
                results[hashable] = results[hashable, default: 0] + 1
            }
        }
        return results.map { party, number in
            (party, number)
        }.sorted { $0.1 > $1.1 }
    }
}

public struct PartyHashable: Hashable {
    var party: String
    var partyColour: String?
    var partyAbbreviation: String?

    public func hash(into hasher: inout Hasher) {
        hasher.combine(party)
        hasher.combine(partyColour)
        hasher.combine(partyAbbreviation)
    }

    public static func ==(lhs: PartyHashable, rhs: PartyHashable) -> Bool {
        return lhs.party == rhs.party &&
               lhs.partyColour == rhs.partyColour &&
               lhs.partyAbbreviation == rhs.partyAbbreviation
    }
}

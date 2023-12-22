import Foundation


class ElectionResult: Codable, Identifiable {
    var result: String
    var isNotional: Bool
    var electorate: Int
    var turnout: Int
    var majority: Int
    var winningParty: PartyModel
    var electionTitle: String
    var electionDate: String
    var electionId: Int
    var isGeneralElection: Bool
    var constituencyName: String

    var id: Int {
        electionId
    }
}


class ElectionResultResultModel: Codable {
    var value: [ElectionResult]
}


class ElectionResultModel: FetchModel {
    public static var shared = ElectionResultModel()
    override private init() {
        super.init()
    }

    public func getResults(for constituency: Int, _ completion: @escaping (ElectionResultResultModel?) -> Void) {
        let url = constructElectionResultUrl(for: constituency)
        FetchModel.base.fetchData(from: url) { data in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(ElectionResultResultModel.self, from: data)
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

    private func constructElectionResultUrl(for constituency: Int) -> String {
        "https://members-api.parliament.uk/api/Location/Constituency/\(constituency)/ElectionResults"
    }
}

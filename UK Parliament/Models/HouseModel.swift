import Foundation


class PartyResultModel: Codable, Identifiable {
    var male: Int
    var female: Int
    var nonBinary: Int
    var total: Int
    var party: PartyModel

    var id: Int {
        party.id
    }
}

class PartyValueModel: Codable, Identifiable {
    var value: PartyResultModel

    var party: PartyModel {
        value.party
    }

    var id: Int {
        party.id
    }
}

class StateOfThePartiesModel: Codable {
    var items: [PartyValueModel]
}


class HouseModel: FetchModel {
    public static var shared = HouseModel()
    override private init() {
        super.init()
    }

    public func getCommonsState(_ completion: @escaping (StateOfThePartiesModel?) -> Void) {
        getHouseState(house: .commons, completion)
    }

    public func getLordsState(_ completion: @escaping (StateOfThePartiesModel?) -> Void) {
        getHouseState(house: .lords, completion)
    }

    public func getHouseState(house: House, _ completion: @escaping (StateOfThePartiesModel?) -> Void) {
        let url = constructStateUrl(house: house)
        FetchModel.base.fetchData(from: url) { data in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(StateOfThePartiesModel.self, from: data)
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

    private func constructStateUrl(house: House) -> String {
        let today = Date.now
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd"
        let dateString = formatter3.string(from: today)

        return "https://members-api.parliament.uk/api/Parties/StateOfTheParties/\(house.rawValue)/\(dateString)"
    }
}

enum House: Int {
    case commons = 1, lords = 2
}

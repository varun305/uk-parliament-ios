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


class HouseModel {
    public static var shared = HouseModel()
    private init() {}

    private var cache: [House: StateOfThePartiesModel] = [:]

    public func getCommonsState(_ completion: @escaping (StateOfThePartiesModel?) -> Void) {
        getHouseState(house: .commons, completion)
    }

    public func getLordsState(_ completion: @escaping (StateOfThePartiesModel?) -> Void) {
        getHouseState(house: .lords, completion)
    }

    public func getHouseState(house: House, _ completion: @escaping (StateOfThePartiesModel?) -> Void) {
        let today = Date.now
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd"
        let dateString = formatter3.string(from: today)

        guard self.cache[house] == nil else {
            completion(self.cache[house])
            return
        }

        let url = URL(string: "https://members-api.parliament.uk/api/Parties/StateOfTheParties/\(house.rawValue)/\(dateString)")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let result = try JSONDecoder().decode(StateOfThePartiesModel.self, from: data)
                    self.cache[house] = result
                    completion(result)
                } catch let error {
                    print(error)
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}

enum House: Int {
    case commons = 1, lords = 2
}

import Foundation


class Interest: Codable, Identifiable {
    var id: Int
    var interest: String
    var createdWhen: String?
    var lastAmendedWhen: String?
    var deletedWhen: String?
    var isCollection: Bool?
}

class RegisteredInterest: Codable, Identifiable {
    var id: Int
    var name: String
    var sortOrder: Int
    var interests: [Interest]
}

class RegisteredInterestValueModel: Codable {
    var value: [RegisteredInterest]
}


class RegisteredInterestModel: FetchModel {
    public static var shared = RegisteredInterestModel()
    override private init() {
        super.init()
    }

    public func getRegisteredInterests(for id: Int, _ completion: @escaping (RegisteredInterestValueModel?) -> Void) {
        let url = getRegisteredInterestsUrl(for: id)
        FetchModel.base.fetchData(from: url) { data in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(RegisteredInterestValueModel.self, from: data)
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

    private func getRegisteredInterestsUrl(for id: Int) -> String {
        "https://members-api.parliament.uk/api/Members/\(id)/RegisteredInterests"
    }
}

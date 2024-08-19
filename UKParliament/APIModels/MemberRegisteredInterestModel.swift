import Foundation

class Interest: Codable, Identifiable {
    var id: Int?
    var interest: String?
    var createdWhen: String?
    var lastAmendedWhen: String?
    var deletedWhen: String?
    var isCollection: Bool?
}

class RegisteredInterest: Codable, Identifiable {
    var id: Int?
    var name: String?
    var sortOrder: Int?
    var interests: [Interest]?
}

class RegisteredInterestValueModel: Codable {
    var value: [RegisteredInterest]?
}

class MemberRegisteredInterestModel {
    public static var shared = MemberRegisteredInterestModel()
    private init() {}

    public func getRegisteredInterests(for id: Int, _ completion: @escaping (RegisteredInterestValueModel?) -> Void) {
        let url = getRegisteredInterestsUrl(for: id)
        FetchModel.base.fetchData(RegisteredInterestValueModel.self, from: url) { result in
            completion(result)
        }
    }

    private func getRegisteredInterestsUrl(for id: Int) -> URL {
        URL(string: "https://members-api.parliament.uk/api/Members/\(id)/RegisteredInterests")!
    }
}

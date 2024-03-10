import Foundation

class ScotlandMember: Codable, Identifiable {
    var personId: Int?
    var photoURL: String?
    var notes: String?
    var birthDate: String?
    var birthDateIsProtected: Bool?
    var parliamentaryName: String?
    var preferredName: String?
    var isCurrent: Bool?

    enum CodingKeys: String, CodingKey {
        case personId = "PersonID"
        case photoURL = "PhotoURL"
        case notes = "Notes"
        case birthDate = "BirthDate"
        case birthDateIsProtected = "BirthDateIsProtected"
        case parliamentaryName = "ParliamentaryName"
        case preferredName = "PreferredName"
        case isCurrent = "IsCurrent"
    }

    var id: Int {
        personId ?? -1
    }
}


class ScotlandMemberModel {
    public static var shared = ScotlandMemberModel()
    private init() {}

    func fetchData(_ completion: @escaping ([ScotlandMember]) -> Void) {
        let url = URL(string: membersUrl)!
        FetchModel.base.fetchData([ScotlandMember].self, from: url) { result in
            completion(result ?? [])
        }
    }

    private let membersUrl = "https://data.parliament.scot/api/members"
}

import Foundation


class MemberModel: Codable, Identifiable {
    var id: Int
    var nameListAs: String
    var nameDisplayAs: String
    var nameFullTitle: String
    var nameAddressAs: String?
    var latestParty: PartyModel
    var gender: String
}

class MemberValueModel: Codable, Identifiable {
    var value: MemberModel
    var id: Int {
        value.id
    }
}

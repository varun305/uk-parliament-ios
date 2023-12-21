import Foundation


class PartyModel: Codable {
    var id: Int
    var name: String
    var abbreviation: String?
    var backgroundColour: String?
    var foregroundColour: String?
    var isLordsMainParty: Bool?
    var isLordsSpiritualParty: Bool?
    var governmentType: Int?
    var isIndependentParty: Bool?
}

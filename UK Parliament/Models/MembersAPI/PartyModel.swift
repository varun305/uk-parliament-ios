import Foundation
import SwiftUI

class PartyModel: Codable, Identifiable, Hashable {
    static func == (lhs: PartyModel, rhs: PartyModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id: Int
    var name: String
    var abbreviation: String?
    var backgroundColour: String?
    var foregroundColour: String?
    var isLordsMainParty: Bool?
    var isLordsSpiritualParty: Bool?
    var governmentType: Int?
    var isIndependentParty: Bool?

    var bgColor: Color {
        Color(hexString: backgroundColour ?? "ffffff")
    }

    var fgColor: Color {
        Color(hexString: foregroundColour ?? "000000")
    }
}

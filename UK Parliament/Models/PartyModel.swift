import Foundation
import SwiftUI

class PartyModel: Codable, Identifiable, Hashable {
    var id: Int?
    var name: String?
    var abbreviation: String?
    var backgroundColour: String?
    var foregroundColour: String?
    var isLordsMainParty: Bool?
    var isLordsSpiritualParty: Bool?
    var governmentType: Int?
    var isIndependentParty: Bool?

    var bgColor: Color {
        Color(hexString: backgroundColour ?? "888888")
    }

    var fgColor: Color {
        Color(hexString: foregroundColour ?? "888888")
    }

    static func == (lhs: PartyModel, rhs: PartyModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}

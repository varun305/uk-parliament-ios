import SwiftUI

struct PartyRow: View {
    var partyResult: PartyResultModel
    var party: PartyModel {
        partyResult.party
    }

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(party.name)
                    .bold()
                Text("\(partyResult.total) MPs")
            }

            Spacer()

            Text((party.abbreviation ?? " ").uppercased())
                .bold()
                .foregroundStyle(Color(UIColor(hexString: party.foregroundColour ?? "000000")))
                .padding(5)
                .background {
                    Color(UIColor(hexString: party.backgroundColour ?? "ffffff"))
                        .mask {
                            RoundedRectangle(cornerRadius: 8)
                        }
                }
        }
    }
}


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

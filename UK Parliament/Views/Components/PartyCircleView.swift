import SwiftUI

struct PartyCircleView: View {
    var party: PartyModel

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color(hexString: party.backgroundColour ?? "ffffff"), lineWidth: 4)
                .frame(width: 60, height: 60)
            Text(party.abbreviation?.uppercased() ?? "")
                .font(.caption)
                .bold()
        }
    }
}

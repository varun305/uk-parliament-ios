import SwiftUI

struct PartyTaggedText: View {
    var text: String
    var party: PartyModel?

    var body: some View {
        Text(text)
            .bold()
            .foregroundStyle(party?.fgColor ?? .black)
            .padding(4)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(party?.bgColor ?? .white)
            }
    }
}

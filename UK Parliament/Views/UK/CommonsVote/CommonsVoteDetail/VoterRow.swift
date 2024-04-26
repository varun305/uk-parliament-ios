import SwiftUI
import SkeletonUI

struct VoterRow: View {
    var voter: any Voter

    var body: some View {
        VStack(alignment: .leading) {
            Text(voter.name ?? "")
                .bold()
            HStack {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hexString: voter.partyColour ?? "0000000"))
                Text(voter.party ?? "")
            }
        }
    }
}

struct VoterRowLoading: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Name")
                .skeleton(with: true)
            Text("Party")
                .skeleton(with: true)
        }
        .frame(height: 40)
    }
}

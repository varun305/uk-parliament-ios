import SwiftUI

struct VoterRow: View {
    var voter: any Voter

    var body: some View {
        VStack(alignment: .leading) {
            Text(voter.name)
                .bold()
            Text(voter.party)
        }
    }
}

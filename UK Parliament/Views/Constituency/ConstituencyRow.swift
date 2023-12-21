import SwiftUI

struct ConstituencyRow: View {
    var consituency: Constituency

    var body: some View {
        VStack(alignment: .leading) {
            Text(consituency.name)
                .bold()
            Text(consituency.member.nameDisplayAs)
        }
    }
}

import SwiftUI

struct ScotlandMemberRow: View {
    var member: ScotlandMember

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading) {
                Text(member.parliamentaryName ?? "")
                    .bold()
                Text("Born " + (member.birthDate ?? "").convertToDate())
                    .font(.footnote)
            }

            Spacer()
        }
    }
}

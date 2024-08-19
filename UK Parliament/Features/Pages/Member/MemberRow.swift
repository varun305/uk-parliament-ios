import SwiftUI
import SkeletonUI

struct MemberRow: View {
    var member: Member

    var body: some View {
        HStack(alignment: .center) {
            MemberPictureView(member: member)
                .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text(member.nameDisplayAs ?? "")
                    .bold()
                caption
            }

            Spacer()
        }
    }
    
    @ViewBuilder
    var caption: some View {
        let partyName = member.latestParty?.name ?? ""
        let constituencyName = member.latestHouseMembership?.membershipFrom ?? ""
        Text(partyName + " • " + constituencyName)
            .accessibilityLabel(Text(partyName + ", " + constituencyName))
            .foregroundStyle(.secondary)
            .font(.footnote)
    }
}

struct MemberRowLoading: View {
    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                Circle()
                    .stroke(.white, lineWidth: 3)
                    .skeleton(with: true)
                Circle()
                    .fill(.white)
                    .padding(5)
                    .skeleton(with: true)
                Text("2")
                    .skeleton(with: true)
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text("")
                    .skeleton(with: true)
                Text("")
                    .skeleton(with: true)
                Text("")
                    .skeleton(with: true)
            }
            Spacer()
        }
        .frame(height: 70)
    }
}

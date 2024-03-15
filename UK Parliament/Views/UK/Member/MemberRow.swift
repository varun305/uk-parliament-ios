import SwiftUI
import SkeletonUI

struct MemberRow: View {
    var member: Member

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(alignment: .center) {
            MemberPictureView(member: member)
                .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text(member.nameDisplayAs ?? "")
                    .bold()
                Text(member.latestParty?.name ?? "")
                    .font(.footnote)
                Text(member.latestHouseMembership?.membershipFrom ?? "")
                    .font(.caption)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .bold()
                .accessibilityHidden(true)
        }
        .padding(10)
        .appOverlay()
        .appBackground(colorScheme: colorScheme)
        .appMask()
        .appShadow()
    }
}

struct MemberRowLoading: View {
    @Environment(\.colorScheme) var colorScheme
    
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
        .padding(10)
        .appOverlay()
        .appBackground(colorScheme: colorScheme)
        .appMask()
        .appShadow()
        .frame(height: 90)
    }
}

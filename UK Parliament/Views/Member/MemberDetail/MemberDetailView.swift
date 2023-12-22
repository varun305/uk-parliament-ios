import SwiftUI

struct MemberDetailView: View {
    var member: Member

    var body: some View {
        Text(member.nameDisplayAs)
    }
}

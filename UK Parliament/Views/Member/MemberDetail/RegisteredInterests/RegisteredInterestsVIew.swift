import SwiftUI

struct RegisteredInterestsVIew: View {
    var member: Member

    var body: some View {
        Text("Registered Interests for \(member.nameDisplayAs)")
    }
}

import SwiftUI

struct LordsBadge: View {
    var body: some View {
        Text("LORDS")
            .font(.footnote)
            .bold()
            .foregroundStyle(.white)
            .padding(2)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(Color.lords)
            }
    }
}

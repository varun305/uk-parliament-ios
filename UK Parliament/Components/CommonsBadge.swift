import SwiftUI

struct CommonsBadge: View {
    var body: some View {
        Text("COMMONS")
            .font(.footnote)
            .bold()
            .foregroundStyle(.white)
            .padding(2)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(Color(hexString: "006e46"))
            }
    }
}

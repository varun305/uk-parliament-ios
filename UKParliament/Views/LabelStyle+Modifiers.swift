import SwiftUI

struct SquircleLabelStyle: LabelStyle {
    var color: Color
    var fontSize: CGFloat = 17

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 16) {
            configuration.icon
                .font(.system(size: fontSize))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .accessibilityHidden(true)
            configuration.title
        }
    }
}

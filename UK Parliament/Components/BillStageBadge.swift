import SwiftUI

struct BillStageBadge: View {
    var stage: Stage
    private var color: Color {
        switch stage.house {
        case "Commons":
            Color.commons
        case "Lords":
            Color.lords
        default:
            Color.accentColor
        }
    }
    private var text: String {
        switch stage.abbreviation {
        case "1R":
            "1"
        case "2R":
            "2"
        case "3R":
            "3"
        case "CS":
            "C"
        case "RS":
            "R"
        case "RA":
            "RA"
        default:
            ""
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: 3)
            Circle()
                .fill(color)
                .padding(5)
            Text(text)
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
    }
}

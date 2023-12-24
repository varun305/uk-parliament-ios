import SwiftUI

struct BillStageRow: View {
    var stage: Stage

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stage.description)
                Text("Sittings: " + stage.stageSittings.map { $0.date.convertToDate() }.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()

            if stage.house == "Commons" {
                CommonsBadge()
            } else if stage.house == "Lords" {
                LordsBadge()
            }
        }
    }
}

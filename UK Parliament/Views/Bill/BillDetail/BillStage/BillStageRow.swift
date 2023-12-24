import SwiftUI

struct BillStageRow: View {
    var stage: Stage

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stage.description)
                Group {
                    if stage.stageSittings.count == 0 {
                        Text("No sittings")
                    } else if stage.stageSittings.count == 1 {
                        Text("Sitting on \(stage.stageSittings[0].date.convertToDate())")
                    } else {
                        Text("Sittings on " + stage.stageSittings.map { $0.date.convertToDate() }.joined(separator: ", "))
                    }
                }
                .font(.footnote)
                .italic()
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

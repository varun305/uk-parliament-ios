import SwiftUI

struct BillStageRow: View {
    var stage: Stage

    var body: some View {
        HStack {
            BillStageBadge(stage: stage)
                .frame(width: 60, height: 60)
            VStack(alignment: .leading) {
                Text(stage.description)
                Group {
                    if stage.stageSittings.count == 0 {
                        Text("Sittings TBA")
                    } else if stage.stageSittings.count == 1 {
                        Text("Sitting on \(stage.stageSittings[0].date.convertToDate())")
                    } else {
                        Text("Sittings from \(stage.stageSittings.sorted { $0.date < $1.date }[0].date.convertToDate())")
                    }
                }
                .font(.footnote)
                .italic()
                .foregroundStyle(.secondary)
            }
        }
    }
}

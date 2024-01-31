import SwiftUI

struct BillStageRow: View {
    var stage: Stage

    var body: some View {
        HStack {
            BillStageBadge(stage: stage)
                .frame(width: 60, height: 60)
            VStack(alignment: .leading) {
                Text(stage.description ?? "")
                stageSittingsView
            }
        }
    }

    @ViewBuilder
    var stageSittingsView: some View {
        Group {
            if let stageSittings = stage.stageSittings {
                if stageSittings.count == 1 {
                    Text("Sitting on \(stageSittings[0].formattedDate)")
                } else if stageSittings.count > 1 {
                    Text("Sittings from \(stageSittings.sorted { $0.formattedDate < $1.formattedDate }[0].formattedDate)")
                }
            } else {
                EmptyView()
            }
        }
        .font(.footnote)
        .italic()
        .foregroundStyle(.secondary)
    }
}

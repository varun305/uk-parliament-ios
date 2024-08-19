import SwiftUI
import SkeletonUI

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
                    Text("Sittings from \(stageSittings.sorted { $0.date ?? "" < $1.date ?? "" }[0].formattedDate)")
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

struct BillStageRowLoading: View {
    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                Circle()
                    .stroke(.white, lineWidth: 3)
                    .skeleton(with: true)
                Circle()
                    .fill(.white)
                    .padding(5)
                    .skeleton(with: true)
                Text("2")
                    .skeleton(with: true)
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text("")
                    .skeleton(with: true)
                Spacer()
                Text("")
                    .frame(width: 50)
                    .skeleton(with: true)
            }
        }
        .frame(height: 60)
    }
}

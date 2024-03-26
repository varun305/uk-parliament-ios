import SwiftUI

struct BillStageSittingsView: View {
    var stage: Stage
    var sittings: [StageSitting] {
        (stage.stageSittings ?? []).sorted { $0.date ?? "" < $1.date ?? "" }
    }

    var body: some View {
        List(sittings) { sitting in
            Text(sitting.formattedDate)
        }
        .listStyle(.grouped)
        .navigationTitle("Sittings")
    }
}

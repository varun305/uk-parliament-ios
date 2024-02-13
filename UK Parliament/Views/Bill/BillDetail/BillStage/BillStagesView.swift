import SwiftUI

struct BillStagesView: View {
    @EnvironmentObject var contextModel: ContextModel
    @StateObject var viewModel: BillStagesViewModel

    var body: some View {
        UnifiedListView(
            viewModel: viewModel,
            rowView: { stage in
                ContextAwareNavigationLink(value: .billPublicationsView(bill: viewModel.bill, stage: stage)) {
                    BillStageRow(stage: stage)
                        .contextMenu(menuItems: {
                            Button("See sittings", systemImage: "person.2.wave.2") {
                                contextModel.manualNavigate(to: .billStageSittingsView(stage: stage))
                            }
                        })
                }
            },
            rowLoadingView: {
                BillStageRowLoading()
            },
            navigationTitle: "Stages, \(viewModel.bill.shortTitle ?? "")"
        )
    }
}

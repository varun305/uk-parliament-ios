import SwiftUI

struct BillStagesView: View {
    @StateObject var viewModel = BillStagesViewModel()
    @State var scrollItem: Stage.ID?
    var bill: Bill
    private var resultsText: String {
        "\(viewModel.numResults) results"
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text(resultsText)
                    .font(.caption)
                    .padding(.horizontal)
                Divider()
                ForEach(viewModel.stages) { stage in
                    BillStageRow(stage: stage)
                        .padding(.horizontal)
                    Divider()
                }
            }
            .scrollTargetLayout()
        }
        .navigationTitle("Stages, \(bill.shortTitle)")
        .navigationBarTitleDisplayMode(.inline)
        .scrollPosition(id: $scrollItem, anchor: .bottom)
        .onChange(of: scrollItem) { _, new in
            if new == viewModel.stages.last?.id {
                viewModel.nextData(for: bill.billId)
            }
        }
        .onAppear {
            if viewModel.stages.isEmpty {
                viewModel.nextData(for: bill.billId, reset: true)
            }
        }
    }
}

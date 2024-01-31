import SwiftUI

struct BillStagesView: View {
    @StateObject var viewModel = BillStagesViewModel()
    var bill: Bill
    private var resultsText: String {
        "\(viewModel.numResults) results"
    }

    var body: some View {
        Group {
            if viewModel.stages.count > 0 {
                scrollView
            } else if viewModel.loading {
                ProgressView()
            } else {
                Text("No data")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .italic()
            }
        }
        .navigationTitle("Stages, \(bill.shortTitle)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.stages.isEmpty {
                viewModel.nextData(for: bill.billId, reset: true)
            }
        }
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            Section(resultsText) {
                ForEach(viewModel.stages) { stage in
                    ContextAwareNavigationLink(value: .billPublicationsView(bill: bill, stage: stage)) {
                        BillStageRow(stage: stage)
                            .onAppear(perform: { onScrollEnd(stage: stage) })
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private func onScrollEnd(stage: Stage) {
        if stage == viewModel.stages.last {
            viewModel.nextData(for: bill.billId)
        }
    }
}

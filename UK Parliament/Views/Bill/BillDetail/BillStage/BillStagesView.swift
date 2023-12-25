import SwiftUI

struct BillStagesView: View {
    @StateObject var viewModel = BillStagesViewModel()
    @State var scrollItem: Stage.ID?
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

    @ViewBuilder
    var scrollView: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text(resultsText)
                    .font(.caption)
                    .padding(.horizontal)
                Divider()
                ForEach(viewModel.stages) { stage in
                    ContextAwareNavigationLink(value: .billPublicationsView(bill: bill, stage: stage), addChevron: true) {
                        BillStageRow(stage: stage)
                    }
                    .foregroundStyle(.primary)
                    .padding(.horizontal)
                    Divider()
                }
            }
            .scrollTargetLayout()
        }
    }
}

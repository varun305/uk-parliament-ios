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
                loadingView
            } else {
                Text("No data")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .italic()
            }
        }
        .navigationTitle("Stages, \(bill.shortTitle ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let billId = bill.billId, viewModel.stages.isEmpty {
                viewModel.nextData(for: billId, reset: true)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List(0..<10) { _ in
            NavigationLink {
                Text("")
            } label: {
                BillStageRowLoading()
            }
            .disabled(true)
        }
        .listStyle(.plain)
        .environment(\.isScrollEnabled, false)
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
        if let billId = bill.billId, stage == viewModel.stages.last {
            viewModel.nextData(for: billId)
        }
    }
}

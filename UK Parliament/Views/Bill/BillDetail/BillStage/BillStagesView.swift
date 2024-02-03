import SwiftUI

struct BillStagesView: View {
    @EnvironmentObject var contextModel: ContextModel
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
                NoDataView()
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
        List {
            Section("") {
                ForEach(0..<20) { _ in
                    DummyNavigationLink {
                        BillStageRowLoading()
                    }
                }
            }
        }
        .listStyle(.grouped)
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
                            .contextMenu(menuItems: {
                                Button("See amendments", systemImage: "doc.text") {
                                    contextModel.manualNavigate(to: .billAmendmentsView(bill: bill, stage: stage))
                                }
                                Button("See sittings", systemImage: "person.2.wave.2") {
                                    contextModel.manualNavigate(to: .billStageSittingsView(stage: stage))
                                }
                            })
                    }
                }
            }
        }
        .listStyle(.grouped)
    }

    private func onScrollEnd(stage: Stage) {
        if let billId = bill.billId, stage == viewModel.stages.last {
            viewModel.nextData(for: billId)
        }
    }
}

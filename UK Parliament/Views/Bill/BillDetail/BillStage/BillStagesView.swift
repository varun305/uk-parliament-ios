import SwiftUI

struct BillStagesView: View {
    @EnvironmentObject var contextModel: ContextModel
    @StateObject var viewModel: BillStagesViewModel
    
    private var resultsText: String {
        "\(viewModel.totalResults) results"
    }

    var body: some View {
        Group {
            if viewModel.items.count > 0 {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
            }
        }
        .navigationTitle("Stages, \(viewModel.bill.shortTitle ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.items.isEmpty {
                viewModel.nextData(reset: true)
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
                ForEach(viewModel.items) { stage in
                    ContextAwareNavigationLink(value: .billPublicationsView(bill: viewModel.bill, stage: stage)) {
                        BillStageRow(stage: stage)
                            .onAppear(perform: { onScrollEnd(stage: stage) })
                            .contextMenu(menuItems: {
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
        if stage == viewModel.items.last {
            viewModel.nextData()
        }
    }
}

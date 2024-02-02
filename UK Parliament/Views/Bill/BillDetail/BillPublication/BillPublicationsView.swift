import SwiftUI

struct BillPublicationsView: View {
    @StateObject var viewModel = BillPublicationsViewModel()
    var bill: Bill
    var stage: Stage?

    private var navigationTitle: String {
        "Publications, \(bill.shortTitle ?? "")"
    }

    var body: some View {
        Group {
            if viewModel.publications.count > 0 {
                scrollView
            } else if viewModel.loading {
                loadingView
            } else {
                NoDataView()
            }
        }
        .searchable(text: $viewModel.search, prompt: Text("Search by publication title or type"))
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                withAnimation {
                    viewModel.sortOrderAscending.toggle()
                }
            } label: {
                Image(systemName: "chevron.up.circle")
                    .rotationEffect(.degrees(viewModel.sortOrderAscending ? 0 : 180))
            }
        }
        .onAppear {
            if let billId = bill.billId {
                viewModel.fetchPublications(for: billId, stageId: stage?.id)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List {
            Section("") {
                ForEach(0..<30) { _ in
                    DummyNavigationLink {
                        BillPublicationRowLoading()
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
            Section("\(viewModel.filteredPublications.count) results") {
                ForEach(viewModel.filteredPublications) { publication in
                    let links = publication.links ?? []
                    let files = publication.files ?? []
                    if links.count + files.count > 0 {
                        ContextAwareNavigationLink(value: .billPublicationLinksView(publication: publication)) {
                            BillPublicationRow(publication: publication)
                        }
                    } else {
                        BillPublicationRow(publication: publication)
                    }
                }
            }
        }
        .listStyle(.grouped)
    }
}

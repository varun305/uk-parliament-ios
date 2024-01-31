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
                Text("No data")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                    .italic()
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let billId = bill.billId {
                viewModel.fetchPublications(for: billId, stageId: stage?.id)
            }
        }
    }

    @ViewBuilder
    var loadingView: some View {
        List(0..<15) { _ in
            NavigationLink {
                Text("")
            } label: {
                BillPublicationRowLoading()
            }
            .disabled(true)
        }
        .listStyle(.plain)
        .environment(\.isScrollEnabled, false)
    }

    @ViewBuilder
    var scrollView: some View {
        List {
            Section("\(viewModel.publications.count) results") {
                ForEach(viewModel.publications) { publication in
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
        .listStyle(.plain)
    }
}
